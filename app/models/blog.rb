class Blog 
  	include Neo4j::ActiveNode

  	property :user_name, type: String
  	property :user_uuid, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime

  	has_many :in, :is_author_of, model_class: User, rel_class: IsAuthorOf
end
