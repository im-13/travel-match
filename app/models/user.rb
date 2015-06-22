class User 
  include Neo4j::ActiveNode

  attr_accessor :password
 
  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String#, constraint: :unique
  property :date_of_birth, type: Date
  property :gender, type: String
  property :password_hash, type: String
  property :password_salt, type: String
  
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  					format: { with: VALID_EMAIL_REGEX }
  # validate date_of_birth
  validates :gender, presence: true
  validates_confirmation_of :password
  validates :password, presence: true

  before_save { self.email = email.downcase } 
  before_save :encrypt_password
  before_save :validate_email_uniqueness

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

#  def validate_email_uniqueness
#    tempUser = User.find_by( email: "#{email}" )
#    if tempUser.nil?



#    if password.present?
#      self.password_salt = BCrypt::Engine.generate_salt
#      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
 #   end
#  end

end


