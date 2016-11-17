class PlacesController < ApplicationController
  before_filter :require_admin, :except => [:where_to_buy, :where_to_buy_search]

  def index
    @places = Place.order(:name).page(params[:page]).per(20)
  end

  def show
    @place = Place.find(params[:id])
  end

  def where_to_buy
    @section = Section.where(:slug => "none").first()
    @dont_show_sorry_message = true
    @featured_product = Feature.where(:is_active => true).first()
  end

  def where_to_buy_search
    @section = Section.where(:slug => "none").first()
    @search_place = Place.new
    @search_place.geocode_from_address(params[:search_place])
    all_places = Place.within(Place::SEARCH_RADIUS, origin: @search_place, unites: :kms)#.order('distance_to asc').limit(10)
    @places = all_places.sort_by{|s| s.distance_to(@search_place)}.take(10)

#    @places = Place.within(Place::SEARCH_RADIUS, :origin => @search_place).order("distance asc").limit(10)
    logger.debug( 'DEBUG >> places ='+ @places.first.inspect)
    @letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"]
    @featured_product = Feature.where(:is_active => true).first()
    render :where_to_buy
  end

  def new
    @place = Place.new
  end

  def edit
    @place = Place.find(params[:id])
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to(@place, :notice => 'Place was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @place = Place.find(params[:id])

    if @place.update(place_params)
      redirect_to(@place, :notice => 'Place was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    redirect_to(places_url)
  end

  private

  def get_letters
    #@letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
  end

  def place_params
    params.require(:place).permit(:name, :address, :city, :province, :country,
      :postal, :contact, :email, :phone, :website, :notes, :latitude,
      :longitude, :gmaps, :generated_address, :description)
  end
end
