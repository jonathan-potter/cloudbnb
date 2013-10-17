class SpacePhotosController < ApplicationController

  def index
    @photos = SpacePhoto.page(selected_page).per(14)
  end

  def ban
    @photo = SpacePhoto.find(params[:id])
    @photo.update_attributes(space_id: -1)
    redirect_to :back
  end

  def unban
    @photo = SpacePhoto.find(params[:id])
    @photo.update_attributes(space_id: nil)
    redirect_to :back
  end

end
