class Discount < ActiveRecord::Base
  validates_presence_of :name, :percentage, :expires_at
  validates_numericality_of :percentage

  has_and_belongs_to_many :products

  before_save :make_slug

  def make_slug
    self.slug = self.name.parameterize
  end
end
