class ShippingRatesController < ApplicationController
  before_filter :require_admin

  def index
    @shipping_rates = ShippingRate.all
  end

  def show
    @shipping_rate = ShippingRate.find(params[:id])
  end

  def new
    @shipping_rate = ShippingRate.new
  end

  def edit
    @shipping_rate = ShippingRate.find(params[:id])
  end

  def create
    @shipping_rate = ShippingRate.new(shipping_rate_params)
    if @shipping_rate.save
      redirect_to(shipping_rates_path, :notice => 'Shipping rate was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @shipping_rate = ShippingRate.find(params[:id])
    if @shipping_rate.update(shipping_rate_params)
      redirect_to(shipping_rates_path, :notice => 'Shipping rate was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @shipping_rate = ShippingRate.find(params[:id])
    @shipping_rate.destroy
    redirect_to(shipping_rates_url)
  end

  private

  def shipping_rate_params
    params.require(:shipping_rate).permit(:name, :country_code, :price, :free_price)
  end
end
