class SpacesController < ApplicationController

  before_filter :require_current_user!, only: [:new, :create]

  def index

    space_relation = Space.includes(:owner_photo, :space_photos)

    if params[:space_filters]
      space_relation = space_relation.find_with_filters(params[:space_filters])
    end

    @spaces = space_relation.page(selected_page).per(14)

    if request.xhr?
      render partial: "spaces/index/space_list", locals: {spaces: @spaces}
    else
      render :index
    end

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
