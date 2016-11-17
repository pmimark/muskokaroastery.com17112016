class Product < ActiveRecord::Base
  MAX_PHOTO_SIZE = 6 # megabytes
  DEFAULT_PRICE = 15.99 # dollars
  DEFAULT_SIZE = 400 # grams
  OPTION_WHOLE_NAME = "Whole Bean"
  OPTION_WHOLE_URL = "whole-bean"
  OPTION_GROUND_NAME = "Ground"
  OPTION_GROUND_URL = "ground"
  OPTION_WHOLE_DECAF_NAME = "Whole Bean Natural Decaf"
  OPTION_WHOLE_DECAF_URL = "whole-bean-natural-decaf"
  OPTION_GROUND_DECAF_NAME = "Ground Natural Decaf"
  OPTION_GROUND_DECAF_URL = "ground-natural-decaf"
  OPTION_COFFEE_PODS_NAME = "Pods"
  OPTION_COFFEE_PODS_URL = "pods"

  #attr_protected :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at

  belongs_to :product_type
  has_and_belongs_to_many :pages
  has_and_belongs_to_many :discounts
  has_many :line_items
  has_many :product_flavours

  before_save :make_slug
  acts_as_list

  has_attached_file :photo,
    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:id/:style/:basename.:extension",
    :styles => {  :original =>      ["900>", :jpg],
                  :large =>         ["660", :jpg],
                  :medium =>        ["330", :jpg],
                  :small =>         ["184", :jpg],
                  :square =>        ["184x184#", :jpg],
                  :tiny =>          ["60", :jpg],
                  :tiny_square =>   ["60x60#", :jpg],
                  :thumb =>         ["30x30#", :jpg],
                  :shopping_cart => ["40x40#", :jpg],
                  :icon =>          ["32x32#", :jpg],
                  :featured =>      ["184x109#", :jpg] }

  validates_presence_of :name, :product_type_id
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 2
  validates :size, :numericality => { :greater_than => 0 }
  validates :acidity,       :numericality => { :greater_than => 0, :less_than => 10 }
  validates :roast,         :numericality => { :greater_than => 0, :less_than => 10 }
  validates :body_quality,  :numericality => { :greater_than => 0, :less_than => 10 }
  validates :price, :format => { :with => /\d+??(?:\.\d{0,2})?/ }, :numericality => { :greater_than => 0 }
  validates_attachment_content_type :photo, :content_type => [  "image/jpeg",
                                                                "image/gif",
                                                                "image/png",
                                                                "image/tiff",
                                                                "image/pjpeg",
                                                                "image/x-png" ]
  validates_attachment_size :photo, :less_than => MAX_PHOTO_SIZE.megabytes
  validates_attachment_presence :photo

  def body_name
    pq = ProductQuality.where(:kind => "body", :value => self.body_quality).first
    pq.blank? ? "None" : pq.name
  end

  def acidity_name
    pq = ProductQuality.where(:kind => "acidity", :value => self.acidity).first
    pq.blank? ? "None" : pq.name
  end

  def roast_name
    pq = ProductQuality.where(:kind => "roast", :value => self.roast).first
    pq.blank? ? "None" : pq.name
  end

  protected

  def make_slug
    self.slug = self.name.parameterize
  end

  def transliterate_file_name
    if photo_file_name
      extension = File.extname(photo_file_name).gsub(/^\.+/, "")
      filename = photo_file_name.gsub(/\.#{ extension }$/, "")
      self.photo.instance_write(:file_name, "#{ transliterate(filename) }.#{ transliterate(extension) }")
    end
  end

  def transliterate(string)
    s = string.downcase
    s = s.gsub(/'/, "")
    s = s.gsub(/[^A-Za-z0-9]+/, " ")
    s = s.strip
    s = s.gsub(/\ +/, "-")
    s
  end

end
