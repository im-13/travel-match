class TripHasAttached 
  include Neo4j::ActiveRel

  from_class Trip
  to_class CarrierwaveImage
  type 'trip_has_attached'
  
  property :created_at, type: DateTime

end
