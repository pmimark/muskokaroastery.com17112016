class ShippingRate < ActiveRecord::Base
  validates_presence_of :name, :country_code, :price, :free_price
  validates_numericality_of :price
  validates_numericality_of :free_price
end
