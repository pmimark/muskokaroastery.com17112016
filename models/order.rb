class Order < ActiveRecord::Base
  GRAMS_PER_POUND = 453.59237

  has_many :line_items
  has_many :payment_notifications
  belongs_to :order_status

  validates_presence_of :name, :phone, :email, :address, :city, :country, :postal
  validates_length_of :name, :maximum => 100
  #validates :email, :email_format => true

  def total_price
    line_items.to_a.sum(&:full_price)
  end

  def total_units
    line_items.to_a.sum(&:quantity)
  end

  def weight
    line_items.to_a.sum(&:weight)
  end

  def split_name
    @splited_name ||= name.split
  end

  def calculated_country_code
    country_name = "Canada"

    if billing_same_as_shipping
      country_name = country
    else
      country_name = shipping_country
    end

    if country_name.blank? || country_name == "Canada"
      country_code = "CA"
    elsif country_name == "United States" || country_name == "United States of America"
      country_code = "US"
    else
      country_code = "INT"
    end

    country_code
  end

  # Default value of free_shipping is 0, so if this is its value, there should be no free shipping.
  def free_shipping?
    free_shipping_threshold = ShippingRate.where(:country_code => calculated_country_code).first.free_price

    total_price > free_shipping_threshold && free_shipping_threshold != 0
  end

  def calculated_shipping_rate
    return ShippingRate.where(:country_code => calculated_country_code).first.price
  end

  def calculated_shipping_fees_by_weight
    number_of_shipping_charges = 1 # default multiplier for shipping charges
    shipping_rate_multiple = DynamicSetting.find_by_name("shipping_rate_multiple").value.to_f # in pounds

    if calculated_country_code == "INT" # international shipments are subject to multiple charges by weight
      shipping_weight_threshold = shipping_rate_multiple * GRAMS_PER_POUND
      number_of_shipping_charges = (weight / shipping_weight_threshold).floor + 1
    end

    number_of_shipping_charges * calculated_shipping_rate
  end

  def calculated_shipping_fees_by_units
    number_of_shipping_charges = 1
    shipping_rate_multiple = DynamicSetting.find_by_name("shipping_rate_multiple").value.to_f # in units

    if calculated_country_code == "INT" # international shipments are subject to multiple charges by units
      number_of_shipping_charges = (total_units / shipping_rate_multiple).floor + 1
    end

    number_of_shipping_charges * calculated_shipping_rate
  end

  # If free_shipping is true, zero-out shipping_rate and shipping_fees.
  def save_shipping_costs
    #self.order_status_id = OrderStatus.where({ :name => "pending payment" }).first.id
    self.free_shipping  = free_shipping?
    self.shipping_rate  = self.free_shipping ? 0 : calculated_shipping_rate
    self.shipping_fees  = self.free_shipping ? 0 : calculated_shipping_fees_by_units
    self.subtotal       = total_price
    self.total          = self.subtotal - self.discount_price + self.shipping_fees
    self.save
  end

  def paypal_encrypted
    splited_name ||= name.split
    splited_shipping_name ||= shipping_name.split
    values = {
      :business       => Settings.paypal_email,
      :cmd            => "_cart",
      :upload         => 1,
      :return         => Settings.paypal_return_url + "?order_id=#{ id }",
      :invoice        => id,
      :currency_code  => Settings.paypal_currency_code,
      :image_url      => Settings.paypal_logo_url,
      :notify_url     => Settings.paypal_notify_url,
      :cert_id        => Settings.paypal_cert_id,
      :secret         => Settings.paypal_notification_secret,
      :handling_cart  => shipping_fees,
      :night_phone_a  => phone,
      :email          => email,
      :discount_amount_cart => discount_price
    }

    # Values passed to Paypal are always the billing details.
    values.merge!({
      :first_name => splited_name.first,
      :last_name  => splited_name.last,
      :address1   => address,
      :address2   => address_optional,
      :city       => city,
      :state      => province,
      :zip        => postal,
      :country    => country
    })

    # NOTE: No longer using this block because it sends the shipping
    # details to Paypal, which is not used for billing.
    #
    # # If billing info is the same as shipping, use that info in Paypal,
    # # otherwise use the shipping info for Paypal.
    # if billing_same_as_shipping
    #   values.merge!({
    #     :first_name => splited_name.first,
    #     :last_name  => splited_name.last,
    #     :address1   => address,
    #     :address2   => address_optional,
    #     :city       => city,
    #     :state      => province,
    #     :zip        => postal,
    #     :country    => country
    #   })
    # else
    #   values.merge!({
    #     :address1   => shipping_address,
    #     :address2   => shipping_address_optional,
    #     :city       => shipping_city,
    #     :state      => shipping_province,
    #     :zip        => shipping_postal,
    #     :country    => shipping_country
    #   })
    #
    #   # If using a different shipping address, and the shipping name is filled out
    #   # use that, otherwise use the billing name.
    #   if shipping_name.blank?
    #     values.merge!({
    #       :first_name => splited_shipping_name.first,
    #       :last_name  => splited_shipping_name.last
    #     })
    #   else
    #     values.merge!({
    #       :first_name => splited_name.first,
    #       :last_name  => splited_name.last
    #     })
    #   end
    # end

    line_items.each_with_index do |item, i|
      item_name = item.item_name + "-" + item.item_option
      unless item.item_flavour.blank?
        item_name += "-" + item.item_flavour
      end
      values.merge!({
        "amount_#{ i + 1 }"       => item.item_price,
        "item_name_#{ i + 1 }"    => item_name,
        "item_number_#{ i + 1 }"  => item.id,
        "quantity_#{ i + 1 }"     => item.quantity,
        "shipping_#{ i + 1 }"     => 0
      })
    end

    encrypt_for_paypal(values)
  end

  PAYPAL_CERT_PEM = File.read("#{ Rails.root }/certs/paypal_cert.pem")
  APP_CERT_PEM    = File.read("#{ Rails.root }/certs/app_cert.pem")
  APP_KEY_PEM     = File.read("#{ Rails.root }/certs/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(
      OpenSSL::X509::Certificate.new(APP_CERT_PEM),
      OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''),
      values.map { |k, v| "#{ k }=#{ v }" }.join("\n"),
      [],
      OpenSSL::PKCS7::BINARY
    )
    OpenSSL::PKCS7::encrypt(
      [OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)],
      signed.to_der,
      OpenSSL::Cipher::Cipher::new("DES3"),
      OpenSSL::PKCS7::BINARY).to_s.gsub("\n", ""
    )
  end

end
