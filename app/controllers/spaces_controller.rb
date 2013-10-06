class SpacesController < ApplicationController

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(params[:space])
    @space.owner_id = current_user.id

    if @space.save
      redirect_to @space
    else
      flash.now[:errors] << @space.errors
      render :new
    end
  end

end
