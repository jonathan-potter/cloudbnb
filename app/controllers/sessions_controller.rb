class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    unless params[:user][:email].nil?
      @user = User.find_by_lowercase_email(params[:user][:email])
    end

    if @user && @user.authenticate(params[:user][:password])
      login_user!(@user)
      redirect_to root_url, :notices => "Welcome back, #{@user.first_name}"
    else
      flash.now[:notices] = ["no matching email/password combination"]
      render "new"
    end
  end

  def destroy
    logout_current_user!

    redirect_to root_url, notices: "Logged out."
  end

end