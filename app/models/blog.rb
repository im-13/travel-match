class Blog 
  	include Neo4j::ActiveNode
	
	attr_accessor 
	#belongs_to :user

  	#property :name, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime

  	has_many :in, :add_user_id_to_blog, model_class: User
end
