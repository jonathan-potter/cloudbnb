class SpacePhoto < ActiveRecord::Base
  attr_accessible :space_id, :url, :flickr_id, :flickr_title, :flickr_owner_name

  validates_presence_of :url, :flickr_id, :flickr_title, :flickr_owner_name
  validates_uniqueness_of :url, :flickr_id

  belongs_to :space

  def self.unattached_photo
    SpacePhoto.where("space_id IS NULL").sample
  end

  def url_small
    self.url[0..-5] + "_s" + self.url[-4..-1]
  end

  def url_medium
    self.url[0..-5] + "_m" + self.url[-4..-1]
  end

end