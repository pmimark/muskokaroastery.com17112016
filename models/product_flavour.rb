class ProductFlavour < ActiveRecord::Base
  before_save :make_slug

  validates_presence_of :name

  belongs_to :product
  acts_as_list :scope => :product

  private

  def make_slug
    self.slug = self.name.parameterize
  end
end
