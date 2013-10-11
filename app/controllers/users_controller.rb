class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @spaces = @user.spaces
  end

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:email]
      @user.email = params[:user][:email].downcase
    end

    @user.photo_url = user_photos.sample.url

    if @user.save
      login_user!(@user)
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors
      render :new
    end

  end

end
