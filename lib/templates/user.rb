class User < ApplicationRecord
  validates :username, :email, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank."}
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  def self.token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    if user.is_password?(password)
      return user
    else
      return nil
    end
  end

  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = digest(password)
  end

  def digest(string)
    string_digest = BCrypt::Password.create(string)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = User.token
    self.save
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= User.token
  end

end
