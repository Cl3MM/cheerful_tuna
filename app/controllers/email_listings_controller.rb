#encoding: utf-8
class EmailListingsController < ApplicationController
  # GET /email_listings
  # GET /email_listings.json
  def index
    @email_listings = EmailListing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @email_listings }
    end
  end

  # GET /email_listings/1
  # GET /email_listings/1.json
  def show
    @email_listing = EmailListing.find(params[:id])

    if @email_listing.countries.nil?
      @listing = []
    else
      select_count = "count(emails.address) as list_size"

      countries = ["SELECT emails.address"]
      countries << "FROM `contacts` LEFT JOIN `emails` ON contacts.id = emails.contact_id"
      countries << "WHERE ("
      countries << "contacts.country in (#{@email_listing.countries_to_sql})"
      countries << "AND contacts.category NOT LIKE 'Sénat%'"
      countries << "AND contacts.is_active"
      countries << ")"

      @listing = Contact.find_by_sql(countries.join(" ")).map(&:address).compact.each_slice(@email_listing.per_line).to_a
      @listing_size = Contact.find_by_sql(countries.join(" ").gsub("emails.address", select_count)).first.list_size

      #@listing = Contact.find(
        #:all,
        #select: "emails.address",
        #conditions: ["contacts.country = ? AND contacts.category NOT LIKE ?", @email_listing.countries,  "Sénat%"],
        #joins: "LEFT JOIN `emails` ON contacts.id = emails.contact_id").map(&:address).compact.each_slice(@email_listing.per_line).to_a
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email_listing }
    end
  end

  # GET /email_listings/new
  # GET /email_listings/new.json
  def new
    @email_listing = EmailListing.new
    @countries = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_listing }
    end
  end

  # GET /email_listings/1/edit
  def edit
    @email_listing = EmailListing.find(params[:id])
    @countries = @email_listing.countries.split(";")
  end

  # POST /email_listings
  # POST /email_listings.json
  def create
    begin
      if params[:country].present?
        Rails.logger.debug params[:country][:name]
        countries = params[:country][:name].join(";")
        Rails.logger.debug countries
        @email_listing = EmailListing.new(params[:email_listing])
        @email_listing.update_attribute(:countries, countries)
      end
      @email_listing.save
    rescue ActiveRecord::RecordNotUnique => e
      if e.message =~ /Duplicate entry/
        flash[:error] = "Sorry, a mailing with the same options already exists. Please try again."
      else
        flash[:error] = "Sorry, something went wrong: #{e.message}."
      end
    end

    respond_to do |format|
      unless flash[:error]
        format.html { redirect_to @email_listing, notice: 'Email listing was successfully created.' }
        format.json { render json: @email_listing, status: :created, location: @email_listing }
      else
        format.html { render action: "new" }
        format.json { render json: @email_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_listings/1
  # PUT /email_listings/1.json
  def update
    @email_listing = EmailListing.find(params[:id])
    if params[:country].present?
      countries = params[:country][:name].join(';')
      @email_listing.update_attribute(:countries, countries)
    end

    respond_to do |format|
      if @email_listing.update_attributes(params[:email_listing])
        format.html { redirect_to @email_listing, notice: 'Email listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_listings/1
  # DELETE /email_listings/1.json
  def destroy
    @email_listing = EmailListing.find(params[:id])
    @email_listing.destroy

    respond_to do |format|
      format.html { redirect_to email_listings_url }
      format.json { head :no_content }
    end
  end
end
