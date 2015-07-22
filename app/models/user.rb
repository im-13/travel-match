require 'bcrypt'

class User 
  include Neo4j::ActiveNode
  include BCrypt
  #include Neo4j::CarrierWave

  attr_accessor :password, :remember_token, :country_of_residence_code, 
                :country_visited, :country_to_visit, :asset

 
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


  serialize :country_visited
  serialize :country_to_visit
  serialize :photos

  has_one :out, :lives_in, model_class: Country, rel_class: LivesIn
  has_many :out, :want_to_visit, model_class: Country, rel_class: WantsToGoTo
  has_many :out, :has_visited, model_class: Country, rel_class: HasBeenTo
  has_many :out, :is_author_of, model_class: Blog, rel_class: IsAuthorOf

  #mount_uploader :asset, AssetUploader
  
  before_save { self.email = email.downcase } 
  before_save :encrypt_password
  before_save :capitalize_names
  before_save { self.last_seen_at = Time.now }
  
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

  def get_age
    if self.date_of_birth?
      time1 = Date.parse(Time.now.to_s)
      age_in_days = time1.mjd - self.date_of_birth.mjd
      age = age_in_days/365    
    end
  end

  def capitalize_names
    self.first_name.capitalize!
    self.last_name.capitalize!
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
  def authenticated?(remember_token)
    puts "INSIDE authenticated?"
    return false if self.remember_hash.nil?
    BCrypt::Password.new(self.remember_hash) == remember_token
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
#  def email_uniqueness
#    undefined method `find_by' - how to call it inside User class?
#    user = Neo4j::ActiveNode::User.find_by(email: "#{self.email}")
#    if user
#      self.errors.add(:email, "Email belongs to an existing account.")
#      self.email = ""
#    end
#  end

end


