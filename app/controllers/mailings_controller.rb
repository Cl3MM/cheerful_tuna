class MailingsController < ApplicationController
  before_filter :authenticate_user!

  # GET /mailings
  # GET /mailings.json
  def index
    @mailings = Mailing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mailings }
    end
  end

  # GET /mailings/1
  # GET /mailings/1.json
  def show
    @mailing = Mailing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mailing }
    end
  end

  # GET /mailings/new
  # GET /mailings/new.json
  def new
    @mailing = Mailing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mailing }
    end
  end

  # GET /mailings/1/edit
  def edit
    @mailing = Mailing.find(params[:id])
  end

  # POST /mailings
  # POST /mailings.json
  def create
    Rails.logger.debug "*" * 100
    params[:mailing][:article_ids]  = params[:mailing][:article_ids].first.split(",") if params[:mailing].has_key? :article_ids
    params[:mailing][:tags]         = params[:mailing][:tags].sort.first              if params[:mailing][:tags].present?
    params[:mailing][:countries]    = params[:mailing][:countries].sort.join(";")     if params[:mailing][:countries].present?
    @mailing = Mailing.new(params[:mailing])

    respond_to do |format|
      if @mailing.save
        #MailingMailer.send_mailing({id: @mailing.id, to: "clement.roullet@gmail.com"}).deliver
        MailingsDispatcherWorker.perform_async("create", id: @mailing.id)
        format.html { redirect_to @mailing, notice: 'Mailing was successfully created.' }
        format.json { render json: @mailing, status: :created, location: @mailing }
      else
        format.html { render action: "new" }
        format.json { render json: @mailing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mailings/1
  # PUT /mailings/1.json
  def update
    params[:mailing][:article_ids]  = params[:mailing][:article_ids].first.split(",") if params[:mailing].has_key? :article_ids
    params[:mailing][:tags]         = params[:mailing][:tags].sort.first              if params[:mailing][:tags].present?
    params[:mailing][:countries]    = params[:mailing][:countries].sort.join(";")     if params[:mailing][:countries].present?
    @mailing = Mailing.find(params[:id])

    respond_to do |format|
      if @mailing.update_attributes(params[:mailing])
        MailingsDispatcherWorker.perform_async("update", id: @mailing.id)
        format.html { redirect_to @mailing, notice: 'Mailing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mailing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailings/1
  # DELETE /mailings/1.json
  def destroy
    @mailing = Mailing.find(params[:id])
    @mailing.destroy

    respond_to do |format|
      format.html { redirect_to mailings_url }
      format.json { head :no_content }
    end
  end
end
