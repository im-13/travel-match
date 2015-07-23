class Viewed 
  include Neo4j::ActiveRel
  require 'date'

  before_save :stamp
  from_class User
  to_class User
  type 'People_You_Viewed'

  property :time_viewed, type: Date

  def stamp
    time = Time.now.to_s
    time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
    self.time_viewed = time
  end

end
