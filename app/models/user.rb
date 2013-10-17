class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :photo_url,
                  :password, :password_confirmation, :session_token

  has_secure_password

  validates :first_name, :last_name, :email, :session_token, presence: true
  validates_uniqueness_of :email
  validates_presence_of :password, on: :create

  after_initialize :ensure_session_token

  has_many :user_photos
  has_many :bookings
  has_many :trips, through: :bookings, source: :space
  has_many :spaces,
  class_name: "Space",
  foreign_key: :owner_id,
  primary_key: :id

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_lowercase_email(email)
    User.where('lower(email) = ?', email.downcase).first
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
  end

  def initiated_bookings
    self.bookings.where("approval_status != 0")
  end

  def photo
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url : "http://placekitten.com/g/400/400"
  end

  def photo_small
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url_small : "http://placekitten.com/g/400/400"
  end

  def photo_medium
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url_medium : "http://placekitten.com/g/400/400"
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
