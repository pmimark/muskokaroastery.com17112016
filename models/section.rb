class Section < ActiveRecord::Base
  has_many :pages, -> { order(:position) }
  has_one :background
  belongs_to :page
  before_save :make_slug

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

end
