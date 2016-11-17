require "fileutils"

class Background < ActiveRecord::Base
  MAX_SIZE = 6 # megabytes

  #attr_protected :image_file_name, :image_content_type, :image_file_size, :image_updated_at

  has_attached_file :image,
    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:id/:style/:basename.:extension",
    :styles => {  :large =>               ["660", :jpg],
                  :preview =>             ["800x400#", :jpg],
                  :preview_small =>       ["400x100#", :jpg],
                  :medium =>              ["330", :jpg],
                  :small =>               ["184", :jpg],
                  :square =>              ["184x184#", :jpg],
                  :tiny =>                ["60", :jpg],
                  :tiny_square =>         ["60x60#", :jpg],
                  :thumb =>               ["30x30#", :jpg],
                  :featured =>            ["184x109#", :jpg] }

  before_post_process :transliterate_file_name

  validates_attachment_content_type :image, :content_type => [  "image/jpeg",
                                                                "image/gif",
                                                                "image/png",
                                                                "image/tiff",
                                                                "image/pjpeg",
                                                                "image/x-png" ]
  validates_attachment_size :image, :less_than => MAX_SIZE.megabytes
  validates_attachment_presence :image

  belongs_to :section

  protected

  def transliterate_file_name
    if image_file_name
      extension = File.extname(image_file_name).gsub(/^\.+/, "")
      filename = image_file_name.gsub(/\.#{ extension }$/, "")
      self.image.instance_write(:file_name, "#{ transliterate(filename) }.#{ transliterate(extension) }")
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
