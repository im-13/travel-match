class Blog 
  include Neo4j::ActiveNode
  property :name, type: String
  property :content, type: String

end
