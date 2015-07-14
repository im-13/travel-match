class Document 
  include Neo4j::ActiveNode
  property :content, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

end
