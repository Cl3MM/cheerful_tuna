# encoding: utf-8

class InvoicesController < ApplicationController

  before_filter :authenticate_user!

  # GET /invoices
  # GET /invoices.json
  def index
    session[:ppage] = (params[:per_page].to_i rescue 25) if (params[:per_page] && (not params[:per_page.blank?] ) )
    @per_page = session[:ppage].to_s
    params.delete :per_page

    @invoices = Invoice.page(params[:page]).per(session[:ppage])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
      format.pdf  do
        locales  = params[:locale].present? && ["english", "français"].include?(params[:locale].downcase) ? params[:locale][0..1].downcase : "en"
        pdf = InvoicePdf.new(@invoice, locales)
        send_data pdf.render, filename: "CERES_invoice_#{@invoice.code}.pdf",
          type: "application/pdf"
          #disposition: "inline"
      end
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new
    @invoice.line_items.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.code = @invoice.generate_code

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end
end
