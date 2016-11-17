require "fileutils"

class Feature < ActiveRecord::Base
  MAX_SIZE = 6 # megabytes

  # attr_protected :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at

  has_attached_file :photo,
    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:id/:style/:basename.:extension",
    :styles => {  :original =>        ["900>", :jpg],
                  :large =>           ["660", :jpg],
                  :medium =>          ["330", :jpg],
                  :small =>           ["184", :jpg],
                  :square =>          ["184x184#", :jpg],
                  :tiny =>            ["60", :jpg],
                  :tiny_square =>     ["60x60#", :jpg],
                  :thumb =>           ["30x30#", :jpg],
                  :featured =>        ["184x109#", :jpg],
                  :sidebar =>         ["164x97#", :jpg] }

  before_post_process :transliterate_file_name

  validates :name, :presence => true, :length => { :maximum => 30 }
  validates :body, :presence => true, :length => { :maximum => 125 }
  validates :link_name, :presence => true, :length => { :maximum => 30 }
  validates :link_url, :presence => true
  validates_attachment_content_type :photo, :content_type => ["image/jpeg", "image/gif", "image/png", "image/tiff"]
  validates_attachment_size :photo, :less_than => MAX_SIZE.megabytes
  validates_attachment_presence :photo

  def self.homepage_left
    feature_id = DynamicSetting.find_by_name("homepage_feature_left_id").value.to_i
    find(feature_id)
  end

  def self.homepage_middle
    feature_id = DynamicSetting.find_by_name("homepage_feature_middle_id").value.to_i
    find(feature_id)
  end

  def self.homepage_right
    feature_id = DynamicSetting.find_by_name("homepage_feature_right_id").value.to_i
    find(feature_id)
  end

  protected

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
