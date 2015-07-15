class Blog 
  	include Neo4j::ActiveNode
	
	attr_accessor 

	property :email, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime

  	has_many :in, :add_user_id_to_blog, model_class: User
  	has_many :out, :has_attached, model_class: Document

end
