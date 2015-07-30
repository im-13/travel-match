class Has 
  include Neo4j::ActiveRel

  from_class Blog
  to_class Comment
  type 'has'
 
  property :created_at, type: DateTime

end
