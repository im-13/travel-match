class Document 
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip

  attr_accessor :attachment 

  property :content, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_neo4jrb_attached_file :attachment 
  
  #has_many :in, :is_tooken_by, model_class: User
  #has_many :in, :has_attached, model_class: Blog, rel_class: HasAttached

end
