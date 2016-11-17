class ShoppingCartMailer < ActionMailer::Base
  default :from => "no-reply@muskokaroastery.com",
          :reply_to => "no-reply@muskokaroastery.com",
          "X-Time-Code" => Time.now.to_i.to_s

  def user_receipt(order)
    @order = order
    mail( :to => @order.email,
          :subject => "ORDER RECEIPT: Muskoka Roastery Coffee Company")
  end

  def new_order_notification(order)
    @order = order
    mail( :to => Settings.email_notifications_address,
          :reply_to => @order.email,
          :subject => "MRCC Notification: New Order")
  end
end
