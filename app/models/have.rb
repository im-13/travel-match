class Have 
  include Neo4j::ActiveRel

  from_class Blog
  to_class Comment
  type 'have'
 
  property :created_at, type: DateTime

end
