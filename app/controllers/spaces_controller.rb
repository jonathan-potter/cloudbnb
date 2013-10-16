class SpacesController < ApplicationController

  before_filter :require_current_user!, only: [:new, :create]

  def index
    if params[:space_filters]
      @spaces = Space.find_with_filters(params[:space_filters])
      @spaces = @spaces[0..13]
    else
      @spaces = Space.find(limit: 14)
    end

    @json = @spaces.to_gmaps4rails
  end

  def show
    @space = Space.find(params[:id])
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(params[:space])
    @space.owner_id = current_user.id
    @space.set_amenities_from_options_list!(params[:space_amenities_indicies])

    @space.set_address_given_components(@space.address,
                                        @space.city,
                                        @space.country)


    if @space.save
      space_photo = SpacePhoto.unattached_photo
      space_photo.update_attributes(space_id: @space.id)
      redirect_to @space
    else
      flash.now[:errors] = @space.errors if @space.errors
      render :new
    end
  end

end
