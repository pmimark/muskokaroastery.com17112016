class FeaturesController < ApplicationController
  before_filter :require_admin

  # GET /features
  # GET /features.xml
  def index
    @features = Feature.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @features }
    end
  end

  # GET /features/1
  # GET /features/1.xml
  def show
    @feature = Feature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  def edit_left
    @feature = Feature.homepage_left
  end

  def edit_middle
    @feature = Feature.homepage_middle
  end

  def edit_right
    @feature = Feature.homepage_right
  end

  # POST /features
  # POST /features.xml
  def create
    @feature = Feature.new(feature_params)

    respond_to do |format|
      if @feature.save
        if @feature.is_active
          deactivate_all_features(@feature.id)
        end
        format.html { redirect_to(@feature, :notice => 'Feature was successfully created.') }
        format.xml  { render :xml => @feature, :status => :created, :location => @feature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update(feature_params)
        if @feature.is_active
          deactivate_all_features(@feature.id)
        end
        format.html { redirect_to(@feature, :notice => 'Feature was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_left
    @feature = Feature.homepage_left
    @feature.update(feature_params)
    redirect_to root_url, :notice => "Left homepage feature was successfully updated."
  end

  def update_middle
    @feature = Feature.homepage_middle
    @feature.update(feature_params)
    redirect_to root_url, :notice => "Middle homepage feature was successfully updated."
  end

  def update_right
    @feature = Feature.homepage_right
    @feature.update(feature_params)
    redirect_to root_url, :notice => "Right homepage feature was successfully updated."
  end

  # DELETE /features/1
  # DELETE /features/1.xml
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to(features_url) }
      format.xml  { head :ok }
    end
  end

  private

  def deactivate_all_features(current_feature_id)
    Feature.all.each do |feature|
      unless feature.id == current_feature_id
        feature.is_active = false
        feature.save
      end
    end
  end

  def feature_params
    params.require(:feature).permit(:name, :body, :link_name, :link_url, :link_type,
      :page_id, :product_id, :photo, :photo_file_name, :photo_content_type,
      :photo_file_size, :photo_updated_at, :is_homepage_feature, :position,
      :is_active)
  end

end
