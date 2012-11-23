class CollectionPointsController < ApplicationController
  # GET /collection_points
  # GET /collection_points.json
  def index
    @collection_points = CollectionPoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collection_points }
    end
  end

  # GET /collection_points/1
  # GET /collection_points/1.json
  def show
    @collection_point = CollectionPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collection_point }
    end
  end

  # GET /collection_points/new
  # GET /collection_points/new.json
  def new
    @collection_point = CollectionPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection_point }
    end
  end

  # GET /collection_points/1/edit
  def edit
    @collection_point = CollectionPoint.find(params[:id])
  end

  # POST /collection_points
  # POST /collection_points.json
  def create
    @collection_point = CollectionPoint.new(params[:collection_point])

    respond_to do |format|
      if @collection_point.save
        format.html { redirect_to @collection_point, notice: 'Collection point was successfully created.' }
        format.json { render json: @collection_point, status: :created, location: @collection_point }
      else
        format.html { render action: "new" }
        format.json { render json: @collection_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collection_points/1
  # PUT /collection_points/1.json
  def update
    @collection_point = CollectionPoint.find(params[:id])

    respond_to do |format|
      if @collection_point.update_attributes(params[:collection_point])
        format.html { redirect_to @collection_point, notice: 'Collection point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection_points/1
  # DELETE /collection_points/1.json
  def destroy
    @collection_point = CollectionPoint.find(params[:id])
    @collection_point.destroy

    respond_to do |format|
      format.html { redirect_to collection_points_url }
      format.json { head :no_content }
    end
  end
end
