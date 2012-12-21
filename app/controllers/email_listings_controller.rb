#encoding: utf-8
class EmailListingsController < ApplicationController
  before_filter :authenticate_user!

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
    unless current_user.is_admin?
      @emails = []
    else
      @emails = @email_listing.emails
    end
    @listing = (@emails.nil? ? [] : @emails.map(&:address).compact.each_slice(@email_listing.per_line).to_a)

    @listing_size = @emails.size
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
    @countries = @email_listing.countries.split(";") rescue []
  end

  # POST /email_listings
  # POST /email_listings.json
  def create
    params[:email_listing][:tags] = params[:email_listing][:tags].sort.first if params[:email_listing][:tags].present?
    params[:email_listing][:countries] = params[:email_listing][:countries].sort.join(";") if params[:email_listing][:countries].present?
    @email_listing = EmailListing.new(params[:email_listing])
    #  @email_listing.update_attribute(:countries, countries)

    respond_to do |format|
      if @email_listing.save
        format.html { redirect_to @email_listing, notice: 'Email listing was successfully created.' }
        #format.json { render json: @email_listing, status: :created, location: @email_listing }
      else
        @countries = params[:email_listing][:countries].split(';') rescue []
        format.html { render action: "new" }
        #format.json { render json: @email_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_listings/1
  # PUT /email_listings/1.json
  def update
    params[:email_listing][:tags] = params[:email_listing][:tags].sort.first if params[:email_listing][:tags].present?
    params[:email_listing][:countries] = params[:email_listing][:countries].sort.join(";") if params[:email_listing][:countries].present?

    @email_listing = EmailListing.find(params[:id])

    respond_to do |format|
      if @email_listing.update_attributes(params[:email_listing])
        format.html { redirect_to @email_listing, notice: 'Email listing was successfully updated.' }
        #format.json { head :no_content }
      else
        @countries = @email_listing.countries_to_a
        format.html { render action: "edit" }
        #format.json { render json: @email_listing.errors, status: :unprocessable_entity }
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
