class HasAttached 
  include Neo4j::ActiveRel

  from_class Blog
  to_class CarrierwaveImage
  type 'has_attached'
  
  property :comments
  property :created_at, type: DateTime

  serialize :comments

end
