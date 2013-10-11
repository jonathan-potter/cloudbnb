module FlickrHelper
  def flickr
    @flickr ||= Flickr.new(key: ENV["FLICKR_KEY"], secret: ENV["FLICKR_SECRET"])
  end

  def flickr_space_photos
    @photos ||= flickr.photos.search("tags" => "beach house")
  end

  def flickr_user_photos
    @photos ||= flickr.photos.search("tags" => "selfie")
  end
end