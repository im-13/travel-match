require 'bcrypt'

class User 
  include Neo4j::ActiveNode
  include BCrypt
  #include Neo4j::CarrierWave

  # is password required here???
  attr_accessor :password, 
                :remember_token, :activation_token, :reset_token,
                :country_of_residence_code, 
                :country_visited, :country_to_visit, :asset, :gravatar_url
 
  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String #constraint: :unique
  property :date_of_birth, type: Date
  property :gender, type: String
  property :password_hash, type: String
  property :remember_hash, type: String
  property :admin, type: Boolean, default: false
  property :last_seen_at, type: DateTime
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :about_me, type: String
  property :avatar, type: String
  mount_uploader :avatar, AssetUploader
  property :activation_hash, type: String
  property :activated, type: Boolean, default: false
  property :activated_at, type: DateTime
  property :reset_hash, type: String
  property :reset_sent_at, type: DateTime

  serialize :country_visited
  serialize :country_to_visit
  serialize :photos

  has_one :out, :lives_in, model_class: Country, rel_class: LivesIn
  has_many :out, :want_to_visit, model_class: Country, rel_class: WantsToGoTo
  has_many :out, :has_visited, model_class: Country, rel_class: HasBeenTo
  has_many :out, :is_author_of, model_class: Blog, rel_class: IsAuthorOf, dependent: :destroy
  has_many :out, :People_You_Viewed, model_class: User, rel_class: Viewed
  has_many :out, :People_You_Were_Viewed_By, model_class: User, rel_class: ViewedBy
  has_many :out, :channel_to, model_class: Conversation, rel_class: Channel
  has_many :out, :follows, model_class: User, rel_class: Follows, dependent: :destroy

  #mount_uploader :asset, AssetUploader
  
  before_save :downcase_email
  before_save :encrypt_password
  before_save :capitalize_names
  before_save { self.last_seen_at = Time.zone.now }
  before_create :create_activation_hash
  
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  					format: { with: VALID_EMAIL_REGEX }
  #validates_date :date_of_birth, :on_or_before => lambda { Date.current }
  #validate date_of_birth
  validates :gender, presence: true
  validates :password, presence: true, allow_nil: true
  validates_confirmation_of :password
  #  validate :email_uniqueness
  #  validates :avatar, presence: true, allow_nil: true

  def get_age
    if self.date_of_birth?
      time1 = Date.parse(Time.zone.now.to_s)
      age_in_days = time1.mjd - self.date_of_birth.mjd
      age = age_in_days/365    
    end
  end

  def encrypt_password
    if password.present?
      self.password_hash = BCrypt::Password.create(password)
    end
  end

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    if user && BCrypt::Password.new(user.password_hash) == password
      puts "User found and passwords match"
      user #returns user
    else
      puts "User NOT found"
      nil
    end
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    BCrypt::Password.create(string)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update(remember_hash: User.digest(self.remember_token))
    puts "REMEMBERED!"
    puts self.remember_hash
    puts self.remember_token
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    hash = send("#{attribute}_hash")
    return false if hash.nil?
    BCrypt::Password.new(hash) == token
  end

  # Activates an account.
  def activate
    update(activated: true)
    update(activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

   # Sets the password reset attributes.
  def create_reset_hash
    self.reset_token = User.new_token
    update(reset_hash: User.digest(reset_token))
    update(reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Forgets a user.
  def forget
    puts "HASH BEFORE FORGET"
    puts self.remember_hash
    update(remember_hash: nil)
    puts "HASH AFTER FORGET"
    puts self.remember_hash
  end

  def country_of_residence
    country = ISO3166::Country[country_of_residence_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def full_name
    first_name + " " + last_name
  end

  def self.get_gravatars
    all.each do |user|
      if !user.avatar?
        user.avatar = URI.parse(user.gravatar_url)
        user.save
        print "."
      end
    end
  end

  def gravatar_url
    stripped_email = email.strip
    downcased_email= stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}?"
  end

  def get_country_visited
    countries = self.has_visited
    return stringify(countries)
=begin
    ret = ""
    countries.each do |country|
      ret << country.name+","
    end
    return ret
=end
  end

  def get_country_to_visit
    countries = self.want_to_visit
    return stringify( countries )
  end

  def stringify( countries )
    ret = ""
    countries.each do |country|
      ret << country.name+","
    end
    if ret.length > 1
      ret = ret[0..-2]
    end
    return ret
  end 

  private

    def create_activation_hash
      self.activation_token  = User.new_token
      self.activation_hash = User.digest(self.activation_token)
    end

    def downcase_email
      self.email = email.downcase
    end

    def capitalize_names
      self.first_name.capitalize!
      self.last_name.capitalize!
    end
#  def email_uniqueness
#    undefined method `find_by' - how to call it inside User class?
#    user = Neo4j::ActiveNode::User.find_by(email: "#{self.email}")
#    if user
#      self.errors.add(:email, "Email belongs to an existing account.")
#      self.email = ""
#    end
#  end

end


