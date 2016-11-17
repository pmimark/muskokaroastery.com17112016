class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create, :destroy]
  before_filter :require_admin, :only => [:index, :show]

  def index
    @users = User.where(:su => false).order(:username)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    authorize_user(@user)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_url, :notice => 'Registration was successful, and you have been automatically logged in.'
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    authorize_user(@user)

    if @user.update(user_params)
      redirect_to root_url, :notice => 'Account was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    puts "Internal Param: #{ params[:internal] }"

    if current_user.is_admin?
      redirect_to users_url, :notice => 'User deleted.'
    else
      current_user_session.destroy
      redirect_to root_url, :notice => 'Your profile has been removed successfully.'
    end
  end

  private

  def authorize_user(user)
    unless user == current_user || current_user.is_admin?
      flash[:warning] = "You are not authorized to access that page."
      redirect_to root_url
      return false
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation,
      :is_admin, :address, :city, :province, :country, :postal, :phone,
      :billing_same_as_shipping, :shipping_address, :shipping_city,
      :shipping_province, :shipping_country, :shipping_postal, :shipping_notes,
      :address_optional, :company, :shipping_address_optional, :shipping_phone,
      :name, :include_in_mailinglist)
  end
end
