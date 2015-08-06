class LivesIn 
  include Neo4j::ActiveRel

  from_class User
  to_class Country
  type 'lives_in'

  property :created_at, type: DateTime
  property :comments

  serialize :comments

end
