class DeliveryRequestsController < ApplicationController

  before_filter :authorize_admin!, except: [:new, :create, :show]

  def delivery_request_pdf
    @delivery_request_pdf = DeliveryRequest.find(params[:id])
    respond_to do |format|
      format.pdf do # show.html.erb
        pdf = DeliveryRequestPdf.new(@delivery_request)
        send_data pdf.render, filename: "Delivery_Request_Form_summary.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  # GET /delivery_requests
  # GET /delivery_requests.json
  def index
    session[:ppage] = (params[:per_page].to_i rescue 25) if (params[:per_page] && (not params[:per_page].blank? ) )
    @per_page = session[:ppage].to_s
    params[:ppage] = session[:ppage]
    params.delete :per_page

    @delivery_requests = DeliveryRequest.order("company ASC").page(params[:page]).per(session[:ppage])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @delivery_requests }
    end
  end

  # GET /delivery_requests/1
  # GET /delivery_requests/1.json
  def show
    @delivery_request = DeliveryRequest.find(params[:id])

    respond_to do |format|
      format.html { render 'joomla/delivery_requests/show' }
      #format.html # show.html.erb
      format.json { render json: @delivery_request }
    end
  end

  # GET /delivery_requests/new
  # GET /delivery_requests/new.json
  #def new
    #@technos = DLV_RQST_TECHNOS.keys.each_slice(3).to_a
    #@delivery_request = DeliveryRequest.new

    #respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @delivery_request }
    #end
  #end

  # GET /delivery_requests/1/edit
  def edit
    @delivery_request = DeliveryRequest.find(params[:id])
  end

  # POST /delivery_requests
  # POST /delivery_requests.json
  def create
    params[:delivery_request][:user_agent] = Rails.env.test? ? "test_user_agent" : request.env['HTTP_USER_AGENT']

    params[:delivery_request][:user_ip] = request.remote_ip
    params[:delivery_request][:referer] = request.env['HTTP_REFERER']

    @delivery_request = DeliveryRequest.new(params[:delivery_request])

    respond_to do |format|
      if @delivery_request.save!  && (Rails.env.test? or verify_recaptcha(model: @delivery_request, message: "Sorry, there was an error reading your Captch, please try again!"))
#      if @delivery_request.save
        format.html { redirect_to @delivery_request, notice: 'Delivery request was successfully created.' }
        format.json { render json: @delivery_request, status: :created, location: @delivery_request }
      else
        @technos = DLV_RQST_TECHNOS.keys.each_slice(3).to_a
        flash.delete(:recaptcha_error)
        format.html { render action: "new" }
        format.json { render json: @delivery_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /delivery_requests/1
  # PUT /delivery_requests/1.json
  def update
    @delivery_request = DeliveryRequest.find(params[:id])

    respond_to do |format|
      if @delivery_request.update_attributes(params[:delivery_request])
        format.html { redirect_to @delivery_request, notice: 'Delivery request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @delivery_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_requests/1
  # DELETE /delivery_requests/1.json
  def destroy
    @delivery_request = DeliveryRequest.find(params[:id])
    @delivery_request.destroy

    respond_to do |format|
      format.html { redirect_to delivery_requests_url }
      format.json { head :no_content }
    end
  end
end
