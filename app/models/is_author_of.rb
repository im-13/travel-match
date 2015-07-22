class IsAuthorOf 
  include Neo4j::ActiveRel
  require 'date'

  before_save :stamp
  from_class User
  to_class Blog
  type 'is_author_of'

  property :date_created, type: Date
  property :comments

  serialize :comments

  def stamp
  	time = Time.now.to_s
	time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
	self.date_created = time
  end

end
