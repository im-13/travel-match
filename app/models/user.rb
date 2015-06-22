class User 
  include Neo4j::ActiveNode
  property :fname, type: String
  property :lname, type: String
  property :email, type: String
  property :dob, type: Date
  property :gender, type: String
  property :password_digest, type: String
  property :password, type: String
  property :password_confirmation, type: String
  property :country_of_residency, type: String

  has_one :out, :lives_in, model_class: Country

end
