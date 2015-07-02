class WantToGoTo  
  include Neo4j::ActiveRel
  require 'date'

  before_save :stamp
  from_class User
  to_class Country
  type 'want_to_go_to'

  property :date_created, type: Date
  property :comments

  serialize :comments

  def stamp
  	time = Time.now.to_s
	time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
	self.date_created = time
  end
end
