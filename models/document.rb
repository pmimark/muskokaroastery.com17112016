require "fileutils"

class Document < ActiveRecord::Base
  MAX_SIZE = 10 # megabytes

  has_attached_file :attachment,
    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:id/:style/:basename.:extension"
  before_post_process :image?, :transliterate_file_name

  do_not_validate_attachment_file_type :attachment
  validates_attachment_size :attachment, :less_than => MAX_SIZE.megabytes
  validates_attachment_presence :attachment

  protected

  def image?
    !(attachment_content_type =~ /^image.*/).nil?
  end

  def transliterate_file_name
    if attachment_file_name
      extension = File.extname(attachment_file_name).gsub(/^\.+/, "")
      filename = attachment_file_name.gsub(/\.#{ extension }$/, "")
      self.attachment.instance_write(:file_name, "#{ transliterate(filename) }.#{ transliterate(extension) }")
    end
  end

  def transliterate(string)
    s = string.downcase
    s = s.gsub(/'/, "")
    s = s.gsub(/[^A-Za-z0-9]+/, " ")
    s = s.strip
    s = s.gsub(/\ +/, "-")
    return s
  end
end
