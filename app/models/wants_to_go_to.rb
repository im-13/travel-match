class WantsToGoTo  
  include Neo4j::ActiveRel

  from_class User
  to_class Country
  type 'wants_to_go_to'

  property :created_at, type: DateTime
  property :comments

  serialize :comments

end
