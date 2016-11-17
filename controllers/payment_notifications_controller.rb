class PaymentNotificationsController < ApplicationController
  before_filter :require_admin, :except => [:create]
  protect_from_forgery :except => [:create]

  def index
    @payment_notifications = PaymentNotification.all
  end

  def show
    @payment_notification = PaymentNotification.find(params[:id])
  end

  def create
    PaymentNotification.create!(  :params => params,
                                  :order_id => params[:invoice],
                                  :status => params[:payment_status],
                                  :transaction_id => params[:txn_id] )
    if session[:cart]
      session[:cart] = nil
    end
    render :nothing => true
  end
end
