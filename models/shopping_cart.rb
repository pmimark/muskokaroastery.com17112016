class ShoppingCart
  attr_reader :items, :promo_discount, :shipping, :discount_id, :order_id

  def initialize()
    # @items = options[:items] || []
    # @promo_discount = options[:promo_discount] || 0
    # @discount_id = options[:discount_id] || nil

    @items = []
    @promo_discount = 0
    @discount_id = nil
  end

  def set_promo_discount(percentage, id)
    @promo_discount = percentage
    @discount_id = id
  end

  def promo_discount_price
    # Go through each product in the list, check if the current discount counts towards it,
    # then generate the discount amount for that product * its quantity
    discount_price = 0
    discount = Discount.find(@discount_id) unless @discount_id.blank?

    if @promo_discount > 0
      @items.each do |item|
        if discount.products.exists?(:id => item.product.id)
          discount_price += item.price * @promo_discount / 100
        end
      end
    end

    return (discount_price * 100).to_i / 100.0 # Round to two decimal places
  end

  # def add_product(product)
  #   current_item = @items.find { |item| item.product == product }
  #   if current_item
  #     current_item.increment_quantity
  #   else
  #     current_item = ShoppingCartItem.new(product)
  #     @items.push current_item
  #   end
  #   return current_item
  # end

  def add_cart_item(product, quantity, option, flavour)
    current_item = @items.find { |item| item.product == product && item.option == option && item.flavour == flavour }
    if current_item
      current_item.add_to_quantity(quantity)
    else
      current_item = ShoppingCartItem.new(product, quantity, option, flavour)
      @items.push current_item
    end
    return current_item
  end

  def remove_product(product, option, flavour)
    item = @items.find { |i| i.product == product && i.option == option && i.flavour == flavour }
    item_index = @items.index(item)
    @items.delete_at(item_index)
    return item.item_id
  end

  def one_more(product)
    current_item = @items.find { |item| item.product == product }
    return current_item.increment_quantity
  end

  def one_less(product)
    current_item = @items.find { |item| item.product == product }
    return current_item.decrement_quantity
  end

  def total_items
    return @items.sum { |item| item.quantity }
  end

  def subtotal
    return @items.sum { |item| item.price }
  end

  def update_item_quantity(item_name, new_quantity)
    @items.each do |item|
      if item.item_id == item_name
        item.change_quantity(new_quantity)
        break
      end
    end
  end

  def total_price
    return subtotal - promo_discount_price
  end

end
