require 'bcrypt'

class User 
  include Neo4j::ActiveNode
  include BCrypt

  attr_accessor :password, :country_of_residency, :country_to_visit, :country_visited
 
  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String#, constraint: :unique
  property :date_of_birth, type: Date
  property :gender, type: String
  property :password_hash, type: String
  #property :country_of_residency, type: String
  #property :country_visited
  #property :country_to_visit 
  property :photos

  serialize :country_visited
  serialize :country_to_visit
  serialize :photos

  has_one :out, :lives_in, model_class: Country, rel_class: LivesIn
  has_many :out, :want_to_visit, model_class: Country, rel_class: WantToGoTo
  has_many :out, :has_visited, model_class: Country, rel_class: HasBeenTo

  before_save { self.email = email.downcase } 
  before_save :encrypt_password
  
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
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
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





