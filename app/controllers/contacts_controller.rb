class ContactsController < ApplicationController

  #before_filter :redirect_member!
  before_filter :authenticate_user!

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.order(:company).page(params[:page]).per(15) #search(params)#.page(params[:page]).per(5)
    if params[:tag]
      @contacts = Contact.tagged_with(params[:tag]).page(params[:page]).per_page(50)
    else
      @contacts = Contact.search(params)
    end
    @q = params[:query].present?
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
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
      @contacts = Contact.tagged_with(params[:tag]).page(params[:page]).per_page(50)
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
      format.html # index.html.erb
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    @contact.update_attribute(:is_active, false) if params[:deactivate].present?
    @contact.update_attribute(:is_active, true) if params[:activate].present?
    @class = @contact.is_active ? "btn" : "btn disabled"

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do # show.html.erb
        if params[:certif].present?
          pdf = CertificatePdf.new(Member.first)
          send_data pdf.render, filename: "CERES_Membership_Certificate_for_#{Member.first.company.capitalize.gsub(/ /,"_")}.pdf",
            type: "application/pdf",
            disposition: "inline"
        else
          pdf = ContactPdf.new(@contact)
          send_data pdf.render, filename: "Contact_#{@contact.company.gsub(/ /, "_").capitalize}.pdf",
            type: "application/pdf",
            disposition: "inline"
        end
      end
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new
    @contact.emails.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
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
      else
        @email_error = "error" if @contact.errors.full_messages.map{|m| m if(m =~ /email/i)}.size > 0
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    flash.clear
    begin
      @contact = Contact.find(params[:id])
      @contact.update_attribute(:updated_by, current_user)
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
