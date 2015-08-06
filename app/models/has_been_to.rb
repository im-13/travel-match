class HasBeenTo 
  include Neo4j::ActiveRel

  from_class User
  to_class Country
  creates_unique_rel
  type 'has_been_to'

  property :created_at, type: DateTime
  property :comments

  serialize :comments

end
