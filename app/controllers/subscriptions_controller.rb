class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
    @owner        = Member.find(params[:member_id]) if params[:member_id].present?
    @subscription = Subscription.new

    respond_to do |format|
      if @owner
        format.html # new.html.erb
        format.json { render json: @subscription }
      else
        format.html { redirect_to :root_url, notice: "Can't create subscription without member parameter." }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create

    # Remove unused documents if no file is attached
    params[:subscription][:documents_attributes].each do |id, hash|
      params[:subscription][:documents_attributes].delete(id) unless hash[:nice_file].present?
    end if params[:subscription][:documents_attributes].any?

    if params[:member_id].present?
      @owner      = Member.find(params[:member_id])
      if @owner
        Rails.logger.debug "#" * 120
        Rails.logger.debug "@owner: #{@owner}"
        Rails.logger.debug "@owner: #{@owner}"
        params[:subscription][:asset_path]  = @owner.asset_path
        params[:subscription][:owner_id]    = @owner.id
        params[:subscription][:owner_id]    = @owner.id
        params[:subscription][:owner_type]  = @owner.class.name
      end
    end
    { status: :new, current: false, paid: false }.each_pair do |k, v|
      params[:subscription][k] = v
    end
    @subscription = Subscription.new(params[:subscription])

    respond_to do |format|
      if @owner && @subscription.save
        format.html { redirect_to @owner, notice: 'Subscription was successfully created.' }
        format.json { render json: @subscription, status: :created, location: @subscription }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @owner, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @owner        = @subscription.owner
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to @owner }
      format.json { head :no_content }
    end
  end
end
