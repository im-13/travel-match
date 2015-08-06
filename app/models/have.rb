class Have 
  include Neo4j::ActiveRel
  require 'date'

  before_save :stamp
  from_class Blog
  to_class Comment
  type 'have'
 
  property :date_created, type: Date

  def stamp
  	time = Time.now.to_s
	  time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
	  self.date_created = time
  end

end
