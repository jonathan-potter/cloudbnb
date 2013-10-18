class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    unless params[:user][:email].nil?
      @user = User.find_by_lowercase_email(params[:user][:email])
    end

    if @user.is_a?(User) && @user.authenticate(params[:user][:password])
      login_user!(@user)
      redirect_to spaces_url
    else
      flash.now[:notices] = ["no matching email/password combination"]
      @user = User.new(params[:user])
      render "new"
    end
  end

  def destroy
    logout_current_user!

    redirect_to root_url, notices: "Logged out."
  end

  def guest_user_sign_in
    @user = User.find(:first, conditions: ["lower(first_name) = ?","guest"])
    login_user!(@user)
    redirect_to spaces_url
  end

end
