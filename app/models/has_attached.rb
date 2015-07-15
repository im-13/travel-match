class HasAttached 
  include Neo4j::ActiveNode
  require 'date'

  before_save :stamp
  from_class Blog
  to_class Document
  type 'has_attached'
 
  property :date_created, type: Date

  def stamp
  	time = Time.now.to_s
	time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
	self.date_created = time
  end
end
