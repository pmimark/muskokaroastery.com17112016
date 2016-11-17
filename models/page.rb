class Page < ActiveRecord::Base
  belongs_to :section
  has_one :section
  has_and_belongs_to_many :products

  before_save :make_slug
  #has_paper_trail
  acts_as_list :scope => :section

  validates_presence_of :name, :body, :section_id
  validates_uniqueness_of :name

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

end
