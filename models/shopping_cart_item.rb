class ShoppingCartItem
  attr_reader :product, :quantity, :option, :flavour

  def initialize(product, quantity, option, flavour)
    @product = product
    @quantity = quantity
    @option = option
    @flavour = flavour
  end

  def change_quantity(new_quantity)
    @quantity = new_quantity
  end

  def add_to_quantity(quantity)
    @quantity += quantity
  end

  def increment_quantity
    @quantity += 1
  end

  def decrement_quantity
    @quantity -= 1
    @quantity = 1 if @quantity < 1
  end

  def name
    @product.name
  end

  def price
    @product.price * @quantity
  end

  def size
    @product.size
  end

  def unit_price
    @product.price
  end

  def discount_price(percentage)
    @product.price * percentage / 100 * @quantity
  end

  def individual_discount_price(percentage)
    @product.price * percentage / 100
  end

  def product_id
    @product.id
  end

  def item_id
    if @product.lists_all_flavours
      "item-#{ @product.id }-#{ @option }-#{ @flavour }"
    else
      "item-#{ @product.id }-#{ @option }"
    end
  end
end
