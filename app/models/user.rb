require 'bcrypt'

class User 
  include Neo4j::ActiveNode
  include BCrypt

  #attr_accessor :password
 
  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String#, constraint: :unique
  property :date_of_birth, type: Date
  property :gender, type: String
  property :password_hash, type: String
  property :country_of_residency, type: String

  has_one :out, :lives_in, model_class: Country
  
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
#  before_save :encrypt_password

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate
    @user = User.find_by(email: params[:email])
    puts "User found"
    if @user.password == params[:password]
      puts "User found and passwords match"
      user #returns user
    else
      puts "User NOT found"
      nil
    end
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





