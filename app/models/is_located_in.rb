class IsLocatedIn 
  include Neo4j::ActiveRel

  from_class Trip
  to_class Country
  type 'is_located_in'

  property :created_at, type: DateTime

end
