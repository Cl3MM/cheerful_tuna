class MembersController < ApplicationController

  #before_filter :redirect_member!
  before_filter :authenticate_user!, except: :generate_certificate

  def generate_certificate
    if params[:checksum].present?
      @member = Member.find_encrypted_member params[:checksum]
      pdf = CertificatePdf.new(@member)
      send_data pdf.render, filename: (@member ? "CERES_Membership_Certificate_for_#{@member.company.capitalize.gsub(/ /,"_")}.pdf" : "CERES_Corrupted_certificate.pdf"),
        #disposition: "inline",
        type: "application/pdf"
    end
  end

  def create_user_name_from_company
    c = Member.generate_username params[:company] if params[:company].present?
    #Rails.logger.debug "c: #{c}"
    #c = MyTools.friendly_user_name params[:company] if params[:company].present?
    c = "Please verify the username" if c.nil?
    #Rails.logger.debug "c: #{c}"
    respond_to do |format|
      format.json { render json: c.to_json }
    end
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.order("company ASC").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])
    @contacts = @member.contacts
    respond_to do |format|
      format.html do # show.html.erb
        if params[:qr_code].present?
          #@member.qr_encode(url = "#{@member.company}_#{@member.address}_#{@member.id}", scale = 4)
          @member.qr_encode(url = "http://www.ceres-recycle.org/member-list/members/nice-sun-pv-co-ltd", scale = 3)
          flash[:notice] = "QRCode create: #{@member.qr_code_asset_url}"
        end
      end
      format.pdf do # show.html.erb
        if params[:certif].present?
          specimen = params[:specimen].present? ? true : nil
          pdf = CertificatePdf.new(@member, specimen)
          send_data pdf.render, filename: "CERES_Membership_Certificate_for_#{@member.company.capitalize.gsub(/ /,"_")}.pdf",
            #disposition: "inline",
            type: "application/pdf"
        end
      end
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
    if params[:member].has_key? :contact_ids
      Rails.logger.debug "*" * 100
      Rails.logger.debug "Params: #{params[:member][:contact_ids]}"
      params[:member][:contact_ids] = params[:member][:contact_ids].first.split(",")
      Rails.logger.debug "Params: #{params[:member][:contact_ids]}"
      Rails.logger.debug "*" * 100
    end
    @member = Member.new(params[:member])
    respond_to do |format|
      # TODO: send email with credentials
      #RegistrationMailer.welcome(user, generated_password).deliver
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update

    @member = Member.find(params[:id])
    if params[:member].has_key? :contact_ids
      Rails.logger.debug "*" * 100
      Rails.logger.debug "Params: #{params[:member][:contact_ids]}"
      params[:member][:contact_ids] = params[:member][:contact_ids].first.split(",")
      Rails.logger.debug "Params: #{params[:member][:contact_ids]}"
      Rails.logger.debug "*" * 100
    end
    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end
end
