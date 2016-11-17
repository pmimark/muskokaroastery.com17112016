class Feedback < ActiveRecord::Base
  validates_presence_of :name, :email, :comment
  validates_length_of :name, :minimum => 2
  validates :email, :format => /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i

  def split_name
    @splited_name ||= name.split
  end
end
