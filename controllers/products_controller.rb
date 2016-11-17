class ProductsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show, :add_to_cart, :category, :categories]
  before_filter :get_product_types, :except => [:index, :show, :destroy, :order, :sort, :add_to_cart]
  before_filter :get_section
  #before_filter :user_country_code, :only => [:index, :show, :add_to_cart]
  #before_filter :estimated_shipping_price, :only => [:index, :show, :add_to_cart]
  #uses_tiny_mce :only => [:new, :create, :edit, :update]

  def index
    if current_user && current_user.is_admin?
      @products = Product.order(:position)
    else
      @products = Product.order(:position).where(:is_active => true, :is_special => false)
    end
    @page = Page.where(position: 1, section_id: @section.id).first
  end

  def category
    @product_type = ProductType.where(:slug => params[:slug]).first
    if current_user && current_user.is_admin?
      @products = @product_type.products.order(:position)
    else
      @products = @product_type.products.where(:is_active => true, :is_special => false).order(:position)
    end
    @page = Page.where(:position => 1, :section_id => @section.id).first
    render :index
  end

  def categories
  end

  def show
    index
    if params[:slug]
      @product = Product.where(:slug => params[:slug]).first
    else
      @product = Product.find(params[:id])
    end
    @client_country_code_temp = client_country_code

    if @product.blank? || (@product.is_active == false && !current_user)
      page_not_found
    end
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if params[:product_flavour_slug]
      @product_flavour = ProductFlavour.where({ :slug => params[:product_flavour_slug] }).first
      @flavour_name = @product_flavour.slug
    elsif params[:product_flavour] # New alternative method of passing flavour param when using collection_select method.
      @product_flavour = ProductFlavour.where({ :slug => params[:product_flavour][:slug] }).first
      @flavour_name = @product_flavour.slug
    else
      @flavour_name = "none"
    end
    if params[:option_whole_quantity].to_i > 0
      @new_option_whole_item = @cart.add_cart_item(@product, params[:option_whole_quantity].to_i, Product::OPTION_WHOLE_URL, @flavour_name)
    end
    if params[:option_ground_quantity].to_i > 0
      @new_option_ground_item = @cart.add_cart_item(@product, params[:option_ground_quantity].to_i, Product::OPTION_GROUND_URL, @flavour_name)
    end
    if params[:option_whole_decaf_quantity].to_i > 0
      @new_option_whole_decaf_item = @cart.add_cart_item(@product, params[:option_whole_decaf_quantity].to_i, Product::OPTION_WHOLE_DECAF_URL, @flavour_name)
    end
    if params[:option_ground_decaf_quantity].to_i > 0
      @new_option_ground_decaf_item = @cart.add_cart_item(@product, params[:option_ground_decaf_quantity].to_i, Product::OPTION_GROUND_DECAF_URL, @flavour_name)
    end
    if params[:option_coffee_pods_quantity].to_i > 0
      @new_option_coffee_pods_item = @cart.add_cart_item(@product, params[:option_coffee_pods_quantity].to_i, Product::OPTION_COFFEE_PODS_URL, @flavour_name)
    end
    respond_to do |format|
      format.html { redirect_to_back(products_path) }
      format.js
    end
  end

  def order
    @products = Product.order(:position)
  end

  def sort
    product = Product.find(params[:id])
    product.insert_at(params[:new_position].to_i)
    render :nothing => true
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)

    if Product.count > 0
      last_product = Product.order(:position).last
      @product.position = last_product.position + 1
    else
      @product.position = 1
    end

    if @product.save
      redirect_to @product, :notice => 'Product was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product, :notice => 'Product was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_url
  end

  private

  def get_product_types
    @product_types = ProductType.order(:id)
  end

  def get_section
    @section = Section.where(slug: "shop").first
  end

  def product_params
    params.require(:product).permit(:name, :description, :body, :price,
      :is_active, :size, :option_ground, :option_ground_decaf,
      :option_whole, :option_whole_decaf, :option_coffee_pods,
      :acidity, :body_quality, :roast,
      :keywords, :product_type_id, :keywords, :position, :lists_all_flavours,
      :include_flavour_descriptions, :include_graphs, :per, :price_alt_txt,
      :out_of_stock, :is_special, :photo, :photo_file_name, :photo_content_type,
      :photo_file_size, :photo_updated_at)
  end

end
