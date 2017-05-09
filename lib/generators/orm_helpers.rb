module AuthThree
  module Generators
    module OrmHelpers

      def model_contents
<<RUBY
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
RUBY
      end

      def migration_data
<<RUBY
      t.string :username, null: false

      t.string :email, null: false

      t.string :password_digest, null: false
      t.string :session_token, null: false
RUBY
      end

      def migration_index_data
<<RUBY

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :session_token, unique: true
RUBY
      end

      private

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_create_users.rb$/).first
      end

      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
