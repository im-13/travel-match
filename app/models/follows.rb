class Follows 
  include Neo4j::ActiveRel

  from_class User
  to_class User
  type 'follows'

  property :created_at, type: DateTime


end
