class LineItemsController < ApplicationController
  before_filter :require_admin, :except => [:new, :create]

  def index
    @line_items = LineItem.all
  end

  def show
    @line_item = LineItem.find(params[:id])
  end

  def new
    @line_item = LineItem.new
  end

  def edit
    @line_item = LineItem.find(params[:id])
  end

  def create
    @product = Product.find(params[:product_id])
    @line_item = LineItem.create!(:order => current_order, :product => @product, :quantity => 1, :item_price => @product.price)
    flash[:notice] = "Added #{ @product.name } to cart."
    redirect_to current_order_url
    # @line_item = LineItem.new(params[:line_item])

    # respond_to do |format|
    #   if @line_item.save
    #     format.html { redirect_to(@line_item, :notice => 'Line item was successfully created.') }
    #     format.xml  { render :xml => @line_item, :status => :created, :location => @line_item }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to(@line_item, :notice => 'Line item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(line_items_url) }
      format.xml  { head :ok }
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity, :order_id, :item_price,
      :item_name, :item_option, :item_flavour)
  end

end
