class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    @spaces = @user.spaces.page(selected_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:email]
      @user.email = params[:user][:email].downcase
    end


    if @user.save
      user_photo = UserPhoto.unattached_photo
      user_photo.update_attributes(user_id: @user.id)
      login_user!(@user)
      redirect_to spaces_url
    else
      flash.now[:errors] = @user.errors
      render :new
    end

  end

end
