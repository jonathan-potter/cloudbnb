module FlickrHelper
  def flickr
    @flickr ||= Flickr.new(key: ENV["FLICKR_KEY"], secret: ENV["FLICKR_SECRET"])
  end
end