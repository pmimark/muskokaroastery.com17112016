class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased

  private

  def mark_order_as_purchased
    # if status == "Completed" && 
    #     #params[:secret] == Settings.paypal_notification_secret &&
    #     params[:receiver_email] == Settings.paypal_email &&
    #     params[:mc_currency] == Settings.paypal_currency_code &&
    #     params[:invoice] == order.id
    if status == "Completed"
      order.update_attribute(:purchased_at, Time.now)
      order.update_attribute(:order_status_id, OrderStatus.find_by_name("paid").id)
      ShoppingCartMailer.user_receipt(order).deliver
      ShoppingCartMailer.new_order_notification(order).deliver
    else
      # Someone is trying to tamper with the system... Fraud going on possibly
    end
  end
end
