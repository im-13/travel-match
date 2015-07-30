class Follows 
  include Neo4j::ActiveRel

  from_class User
  to_class User
  type 'follows'

  property :follower_id, type: String
  property :followed_id, type: String
  property :created_at, type: DateTime


end
