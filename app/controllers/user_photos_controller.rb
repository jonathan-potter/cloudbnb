class UserPhotosController < ApplicationController

  def index
    @user_photos = UserPhoto.page(selected_page).per(14)
  end

  def ban
    @photo = UserPhoto.find(params[:id])
    @photo.update_attributes(user_id: -1)
    redirect_to :back
  end

  def unban
    @photo = UserPhoto.find(params[:id])
    @photo.update_attributes(user_id: nil)
    redirect_to :back
  end

end
