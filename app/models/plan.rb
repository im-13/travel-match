class Plan
  include Neo4j::ActiveRel

  from_class User
  to_class Trip

  type 'plan'

  property :created_at, type: DateTime

end
