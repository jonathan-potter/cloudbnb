class UserPhoto < ActiveRecord::Base
  attr_accessible :user_id, :url, :flickr_id, :flickr_title, :flickr_owner_name

  validates_presence_of :url, :flickr_id, :flickr_title, :flickr_owner_name
  validates_uniqueness_of :url, :flickr_id

  belongs_to :user
  has_many :spaces,
  class_name: "Space",
  foreign_key: :owner_id,
  primary_key: :user_id

  def self.unattached_photo
    UserPhoto.where("user_id IS NULL").sample
  end

  def url_small
    self.url[0..-5] + "_s" + self.url[-4..-1]
  end

  def url_medium
    self.url[0..-5] + "_m" + self.url[-4..-1]
  end

end
