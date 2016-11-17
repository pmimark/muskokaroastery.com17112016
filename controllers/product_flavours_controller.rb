class ProductFlavoursController < ApplicationController
  before_filter :require_admin
  before_filter :get_product

  def index
    @product_flavours = ProductFlavour.where(:product_id => @product.id).order(:product_id, :position)
  end

  def show
    @product_flavour = ProductFlavour.find(params[:id])
  end

  def sort
    flavour = ProductFlavour.find(params[:id])
    flavour.insert_at(params[:new_position])

    render :nothing => true
  end

  def new
    @product_flavour = ProductFlavour.new
  end

  def edit
    @product_flavour = ProductFlavour.find(params[:id])
  end

  def create
    @product_flavour = ProductFlavour.new(product_flavour_params)
    last_flavour = ProductFlavour.where(:product_id => @product.id).order(:position).last
    if last_flavour.present?
      @product_flavour.position = last_flavour.position + 1
    else
      @product_flavour.position = 1
    end
    @product_flavour.product_id = @product.id

    if @product_flavour.save
      redirect_to(product_product_flavours_path(@product), :notice => 'Product flavour was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @product_flavour = ProductFlavour.find(params[:id])

    if @product_flavour.update(product_flavour_params)
      redirect_to(product_product_flavours_path(@product), :notice => 'Product flavour was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @product_flavour = ProductFlavour.find(params[:id])
    @product_flavour.destroy

    redirect_to(product_product_flavours_url(@product))
  end

  private

  def get_product
    @product = Product.find(params[:product_id])
  end

  def product_flavour_params
    params.require(:product_flavour).permit(:name, :description, :position, :out_of_stock)
  end
end
