class Follow
  include Neo4j::ActiveRel

  from_class User
  to_class User
  type 'following'
  creates_unique_rel

  property :follower_id, type: String
  property :followed_id, type: String
  property :created_at, type: DateTime

end
