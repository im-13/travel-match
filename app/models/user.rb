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
  property :country_of_residency, type: String
  property :country_visited
  property :country_to_visit 

  serialize :country_visited
  serialize :country_to_visit
  
  has_one :out, :lives_in, model_class: Country
  has_many :out, :want_to_visit, model_class: Country 
  has_many :out, :has_visited, model_class: Country
  
=begin
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  					format: { with: VALID_EMAIL_REGEX }
  # validate date_of_birth
  validates :gender, presence: true
  validates :password, presence: true
  validates_confirmation_of :password
  #  validate :email_uniqueness

  before_save { self.email = email.downcase } 
  before_save :encrypt_password
=end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

#  def email_uniqueness
#    undefined method `find_by' - how to call it inside User class?
#    tempUser = Neo4j::ActiveNode::Labels::ClassMethods.find_by(email: "#{self.email}")
#    if !tempUser.nil?
#      self.errors.add(:email, "Email belongs to an existing account.")
#      self.email = ""
#    end
#  end

end





