class OrdersController < ApplicationController
  before_filter :require_admin, :except => [:new, :create]

  def index
    @orders = Order.order("created_at desc").page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
    shipping_country = ""

    if @order.billing_same_as_shipping
      shipping_country = @order.country
    else
      shipping_country = @order.shipping_country
    end

    if shipping_country == "United States of America"
      shipping_country = "United States"
    end

    if shipping_country == "Canada" || shipping_country == "United States"
      @shipping_rate = ShippingRate.find_by_name(shipping_country)
    else
      @shipping_rate = ShippingRate.find_by_name("International")
    end
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to(@order, :notice => 'Order was successfully created.') }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  private

  def order_params
    params.require(:order).permit(:email, :address, :city, :province, :country,
      :postal, :phone, :total, :order_status_id, :purchased_at, :subtotal,
      :shipping_fees, :shipping_name, :free_shipping, :discount_percentage,
      :discount_price,
      :billing_same_as_shipping, :shipping_address, :shipping_city,
      :shipping_province, :shipping_country, :shipping_postal, :shipping_notes,
      :address_optional, :company, :shipping_address_optional, :shipping_phone,
      :name, :include_in_mailinglist)
  end

end
