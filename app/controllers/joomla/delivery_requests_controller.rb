class Joomla::DeliveryRequestsController < ApplicationController

    before_filter :authorize_admin!, except: [ :new, :create, :show, :delivery_request_pdf, :nearbys ]

    def nearbys
      render json: DeliveryRequest.collection_points_nearbys(params)
    end

    def delivery_request_pdf
      @delivery_request = DeliveryRequest.find(params[:id])

      respond_to do |format|
        format.pdf do # show.html.erb
          pdf = DeliveryRequestPdf.new(@delivery_request)
          send_data pdf.render, filename: "Delivery_Request_Form_summary.pdf",
            type: "application/pdf"#, disposition: "inline"
        end
      end
    end

    # GET /delivery_requests/1
    # GET /delivery_requests/1.json
    def show
      Rails.logger.debug "*" * 120
      Rails.logger.debug "FLASH:\n#{flash.to_json}"
      @delivery_request = DeliveryRequest.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @delivery_request }
      end
    end

    # GET /delivery_requests/new
    # GET /delivery_requests/new.json
    def new
      @delivery_request = DeliveryRequest.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @delivery_request }
      end
    end

    # POST /delivery_requests
    # POST /delivery_requests.json
    def create
      params[:delivery_request][:user_agent]  = Rails.env.test? ? "test_user_agent" : request.env['HTTP_USER_AGENT']

      params[:delivery_request][:user_ip]     = request.remote_ip
      params[:delivery_request][:referer]     = request.env['HTTP_REFERER']

      @delivery_request = DeliveryRequest.new(params[:delivery_request])

      respond_to do |format|
        #if (Rails.env.test? || verify_recaptcha(model: @delivery_request, message: "Sorry, there was an error reading your Captcha, please try again!") ) && @delivery_request.save
        if @delivery_request.save
        #binding.pry
        flash.delete(:recaptcha_error) if flash.key?(:recaptcha_error)
        @delivery_request.delay.send_confirmation_email
        format.html { redirect_to joomla_delivery_request_path(@delivery_request), notice: 'Delivery request was successfully created.' }
        format.json { render json: @delivery_request, status: :created, location: @delivery_request }
      else
        flash.delete(:recaptcha_error) if flash.key?(:recaptcha_error)
        format.html { render action: :new }
        format.json { render json: @delivery_request.errors, status: :unprocessable_entity }
      end
    end
  end

end
