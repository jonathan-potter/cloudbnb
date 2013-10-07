class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email,
                  :password, :password_confirmation, :session_token

  has_secure_password

  validates :first_name, :last_name, :email, :session_token, presence: true
  validates_uniqueness_of :email
  validates_presence_of :password, on: :create

  after_initialize :ensure_session_token

  has_many :bookings

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_lowercase_email(email)
    User.find_by_email(email.downcase)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
