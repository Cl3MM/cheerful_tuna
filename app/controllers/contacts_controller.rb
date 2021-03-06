class ContactsController < ApplicationController

  #before_filter :redirect_member!
  before_filter :authenticate_user!

  def activation
    @contact = Contact.find(params[:id])
    @contact.update_attribute(:is_active, false) if params[:deactivate].present?
    @contact.update_attribute(:is_active, true) if params[:activate].present?
    @class = @contact.is_active ? "btn" : "btn disabled"
    redirect_to :back
  end

  def search
    respond_to do |format|
      format.html
    end
  end
  # GET /contacts
  # GET /contacts.json
  def index
    session[:ppage] = (params[:per_page].to_i rescue 25) if (params[:per_page] && (not params[:per_page.blank?] ) )
    @per_page = session[:ppage].to_s
    params[:ppage] = session[:ppage]

    if params[:member_query].present?
      @contacts = Contact.where("first_name LIKE ? OR last_name LIKE ? OR company LIKE ?", "%#{params[:member_query]}%", "%#{params[:member_query]}%", "%#{params[:member_query]}%")
    elsif params[:tag]
      @contacts = Contact.search(params).tagged_with(params[:tag]).page(params[:page]).per(session[:ppage])
    else
      @contacts = Contact.search(params)
    end

    params.delete :ppage
    params.delete :per_page

    @q = params[:query].present?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts.map{ |c| {id: c.id, text: c.to_label} } }
      # format.json { render json: @contacts.map{ |c| {id: c.id, text: {company: c.company, first_name: c.first_name, last_name: c.last_name }  } } }
    end
  end

  def more_contacts
    id = params[:id].to_i rescue 0
    5.times do
      break if Contact.find_by_id(id)
      id -= 1
    end unless id.nil?
    @contacts = (id.nil? ? nil : Contact.find_all_by_id(id-10..id).reverse)
    respond_to do |format|
      format.js { render partial: "more_contacts" }
    end unless @contacts.nil?
  end

  def tag_cloud
    if params[:tag]
      #@contacts = Contact.tagged_with(params[:tag]).page(params[:page]).per_page(50)
      @contacts = Contact.tagged_with(params[:tag]).page(params[:page]).per(session[:ppage])
      @tag = params[:tag]
    end
    respond_to do |format|
      format.html
    end
  end

  def statistics
    @last_ten = Contact.last(10).reverse
    @contacts_by_countries = Contact.group(:country).count.sort_by{|k,v| v}.map{|name, val| {label: name, value: val} if val > 10}.compact

    respond_to do |format|
      format.html
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    @contact.update_attribute(:is_active, false) if params[:deactivate].present?
    @contact.update_attribute(:is_active, true) if params[:activate].present?
    @class = @contact.is_active ? "btn" : "btn disabled"
    @next_contact = @contact.next_company
    @previous_contact = @contact.previous
    @members = @contact.members

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    if params[:member].present? && params[:member].respond_to?(:to_i) # prefill new form with member's data
      if @member = Member.find(params[:member])
        @contact = Contact.new( company:          @member.company,
                                country:          @member.country,
                                address:          @member.address,
                                city:             @member.city,
                                postal_code:      @member.postal_code,
                                is_ceres_member:  true,
                              )
        tag_list = @member.activity_list + @member.brand_list
        tag_list << "member"
        @contact.tag_list = tag_list.join(',')
      end
    end
    @contact ||= Contact.new
    @contact.emails.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json:    @contact }
      format.js   { render template: 'contacts/new' }
    end
      # { render partial: "new" }
  end

  # GET /contacts/1/edit
  def duplicate
    @contact = Contact.find(params[:id]).duplicate
    @contact.emails.new
    render "edit"
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    @count = 0
  end

  # POST /contacts
  # POST /contacts.json
  def create
    flash.clear
    begin
      @contact = Contact.new(params[:contact])
      @contact.update_attribute(:user_id, current_user.id)
    rescue ActiveRecord::RecordNotUnique => e
      if e.message =~ /for key 'index_emails_on_address'/
        email   = e.message.scan(/Duplicate entry '(.*)' for key 'index_emails_on_address'.*/).flatten.first
        err = ["the email address <strong>'#{email.html_safe}'</strong>",
               "Check the emails fields"]
      else
        company = params[:contact][:company] || "ERROR"
        country = params[:contact][:country] || "ERROR"
        err = ["the company <strong>\"#{company.html_safe}\"</strong> in the country: <strong>\"#{country.html_safe}\"</strong>",
               "Check the company, country, address and first name fields"]
      end
      flash[:error] = <<EOL
<h3>An error prevented the reccord from being saved (duplicate entry):</h3>
Sorry, #{err.first.html_safe} already exists in the database. Please take one of the following action:
<ul>
  <li>#{err.last.html_safe}</li>
  <li>Do not create the contact, but find and update the already existing company using the search form on the main contact page</li>
</ul>
EOL
      #flash[:error] +=  e.message
    end
    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_path, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
        format.js   { render template: 'contacts/ajax_new_contact_success' }
      else
        @email_error = "error" if @contact.errors.full_messages.map{|m| m if(m =~ /email/i)}.size > 0
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.js   { render template: 'contacts/_form' }
        #format.js   { render template: 'contacts/new' }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    flash.clear
    begin
      @contact = Contact.find(params[:id])
      @contact.update_attribute(:updated_by, current_user.id)
    rescue ActiveRecord::RecordNotUnique => e
      if e.message =~ /for key 'index_emails_on_address'/
        email   = e.message.scan(/Duplicate entry '(.*)' for key 'index_emails_on_address'.*/).flatten.first
        err = ["the email address <strong>'#{h(email)}'</strong>",
               "Check the emails fields"]
      else
        company = params[:contact][:company] || "ERROR"
        country = params[:contact][:country] || "ERROR"
        err = ["the company <strong>\"#{h(company)}\"</strong> in the country: <strong>\"#{h(country)}\"</strong>",
               "Check the company, country, address and first name fields"]
      end
      flash[:error] = <<EOL
<h3>An error prevented the reccord from being saved (duplicate entry):</h3>
Sorry, #{h(err.first)} already exists in the database. Please take one of the following action:
<ul>
  <li>#{h(err.last)}</li>
  <li>Do not create the contact, but find and update the already existing company using the search form on the main contact page</li>
</ul>
EOL
    end
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])

    @contact.destroy
    #@contact.version

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end
