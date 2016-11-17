class BlogCategory < ActiveRecord::Base
  has_many :blog_posts

  before_save :make_slug
  acts_as_list

  validates :name, :presence => true, :length => { :minimum => 3 }

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

end
