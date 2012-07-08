class ContactsController < ApplicationController

  before_filter :authenticate_user!

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.order(:company).page(params[:page]).per(15) #search(params)#.page(params[:page]).per(5)
    @contacts = Contact.search(params)
    @q = params[:query].present?
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do # show.html.erb
        pdf = ContactPdf.new(@contact)
        send_data pdf.render, filename: "Contact_#{@contact.company.gsub(/ /, "_").capitalize}.pdf",
                            type: "application/pdf",
                            disposition: "inline"
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
  end

  # POST /contacts
  # POST /contacts.json
  def create
    begin
      @contact = Contact.new(params[:contact])
      @contact.update_attribute(:user_id, current_user.id)
      @contact.save
    rescue ActiveRecord::RecordNotUnique => e
      if e.message =~ /for key 'index_emails_on_address'/
        email   = e.message.scan(/Duplicate entry '(.*)' for key 'index_emails_on_address'.*/).flatten.first
        err = ["the email address <strong>'#{email}'</strong>",
               "Check the emails fields"]
      else
        company = params[:contact][:company] || "ERROR"
        country = params[:contact][:country] || "ERROR"
        err = ["the company <strong>\"#{company}\"</strong> in the country: <strong>\"#{country}\"</strong>",
               "Check the company, country, address and first name fields"]
      end
      #flash[:error] = "<br /> #{e}"
      flash[:error] = <<EOL
<h3>An error prevented the reccord from being saved (duplicate entry):</h3>
Sorry, #{err.first} already exists in the database. Please take one of the following action:
<ul>
	<li>#{err.last}</li>
	<li>Find and update the already existing company using the search form on the main contact page</li>
</ul>
EOL
    end
=begin
    @contact.version
    if current_user
      @contact.update_attribute(:updated_by, current_user)
    else
      Rails.logger.info "[ERROR] Contact creation without current_user :#{params.attributes}"
      @contact.update_attribute(:updated_by, "ERROR")
    end
=end
    respond_to do |format|
      unless flash[:error]
        format.html { redirect_to contacts_path, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])
    @contact.update_attribute(:updated_by, current_user)

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
