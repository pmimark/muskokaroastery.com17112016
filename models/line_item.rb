class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def full_price
    item_price * quantity
  end

  def weight
    product.size * quantity
  end

end
