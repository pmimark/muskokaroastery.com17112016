class User < ActiveRecord::Base
  # attr_accessible :name, :email, :password, :password_confirmation, :username,
  #                 :address, :address_optional, :city, :province, :country,
  #                 :postal, :phone, :billing_same_as_shipping,
  #                 :shipping_address, :shipping_address_optional,
  #                 :shipping_city, :shipping_province, :shipping_country,
  #                 :shipping_postal, :shipping_notes, :shipping_phone,
  #                 :company, :include_in_mailinglist

  has_many :orders

  default_scope { order("id desc") }
  scope :admin, Proc.new { where(:is_admin => true) }
  scope :disabled, Proc.new { where(:disabled => true) }
  scope :enabled, Proc.new { where(:disabled => false) }

  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  class << self
    def is_admin?
      return self.is_admin
    end
  end

  validates :email, :presence => true, :uniqueness => true, :format => { :with => /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i }
  validates :password, :presence => { :on => :create }
  validates :password_confirmation, :presence => { :on => :create }

  def deliver_password_reset_instructions!
    reset_perishable_token!
    FeedbackMailer.password_reset_instructions(self).deliver
  end

end
