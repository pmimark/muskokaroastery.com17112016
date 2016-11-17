class BlogPost < ActiveRecord::Base
  belongs_to :blog_category

  before_save :make_slug
  #has_paper_trail
  paginates_per 10

  validates_presence_of :name, :body, :blog_category_id, :created_at
  validates_uniqueness_of :name

  def datetime_html5
    created_at.strftime("%Y-%m-%dT%H:%M:%S-%Z")
  end

  def date_homepage
    created_at.strftime("%e %B %Y")
  end

  def datetime_blog
    created_at.strftime("%e %B %Y, @%l:%M%P")
  end

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

end
