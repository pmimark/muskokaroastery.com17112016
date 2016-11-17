class ProductType < ActiveRecord::Base
  has_many :products

  before_save :make_slug

  validates_presence_of :name
  validates_length_of :name, :minimum => 2

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

end
