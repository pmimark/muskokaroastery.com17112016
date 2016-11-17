class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user
  before_filter :get_sections
  before_filter :get_blog_categories
  before_filter :find_cart
  before_filter :calculate_estimated_shipping_price
  before_filter :estimate_shipping_fees

  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def page_not_found
    redirect_to '/404.html', :stauts => 404
  end

  def redirect_to_back(default = root_url)
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_order
    session[:order_id] ||= Order.create!.id
    @current_order ||= Order.find(session[:order_id])
  end

  def current_shopping_cart
    session[:cart] ||= ShoppingCart.new
  end

  def find_cart
    @cart = (session[:cart] ||= ShoppingCart.new)
  end

  def get_sections
    @sections = Section.order(:position).limit(6)
    @no_section = Section.find_by_slug("none")
    @homepage_section = Section.find_by_slug("homepage")
    @hidden_section = Section.find_by_slug("hidden")
    @product_types = ProductType.order(:id)
  end

  def get_blog_categories
    @blog_categories = BlogCategory.order(:position).all
  end

  def require_user
    unless current_user
      store_location
      flash[:warning] = "You must be logged in to access this page."
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:warning] = "You must be logged out to access this page."
      redirect_to root_url
      return false
    end
  end

  def require_admin
    unless current_user && current_user.is_admin?
      store_location
      flash[:warning] = "You are not authorized to access that page."
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def back_or_root_path
    session[:return_to] || root_path
  end

  def client_country_code
    session[:country_code] ||= find_country_code
  end

  def find_country_code
    if request.remote_ip.blank? || !(defined?(GeoLocation) == 'constant' && GeoLocation.class == Class)
      return "ZZ"
    else
      location = GeoLocation.find(request.remote_ip)
      #location = GeoLocation.find('46.36.198.121') # INT
      #location = GeoLocation.find('24.24.24.24') # US
      #location = GeoLocation.find('76.65.209.5') # CA
      return location[:country_code]
    end
  end

  # estimate shipping based on IP address lookup
  def calculate_estimated_shipping_price
    shipping_rate = ShippingRate.where(:country_code => client_country_code).first
    if shipping_rate.blank?
      shipping_rate = ShippingRate.where(:country_code => "INT").first
    end
    @estimated_shipping_price = shipping_rate.price
  end

  def calculate_shipping_fees(number_of_items_purchased, shipping_rate_price)
    shipping_rate_multiple = DynamicSetting.find_by_name("shipping_rate_multiple").value.to_i
    number_of_shipping_charges = (number_of_items_purchased / shipping_rate_multiple).floor
    number_of_shipping_charges = 1 if number_of_shipping_charges == 0
    return number_of_shipping_charges * shipping_rate_price
  end

  def estimate_shipping_fees
    @estimated_shipping_fees = calculate_shipping_fees(@cart.total_items, @estimated_shipping_price)
  end

end
