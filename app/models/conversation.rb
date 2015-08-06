class Conversation 
  include Neo4j::ActiveNode

  before_save :stamp
 
  property :date_created, type: DateTime
  property :last_viewed, type: DateTime
  #users are referenced by their id
  property :user1, type: String
  property :user2, type: String

  #has many users pointing to it
  has_many :in, :channel_to, model_class: User, rel_class: Channel

  #has many mesages belonging to it  
  has_many :in, :belong_to, model_class: Message, rel_class: BelongTo

  def stamp
  	time = Time.now.to_s
    time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M:%S")
    self.date_created = time
    self.last_viewed = time
  end

  def time_stamp
    time = Time.now.to_s
    time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M:%S")
    self.last_viewed = time
  end

  def get_other( current_user_id , convo )
  	if current_user_id.to_s.eql? convo.user1
  		return User.find_by(uuid: convo.user2 )	
  	else
  		return User.find_by(uuid: convo.user1 )
  	end
  end

  def get_messages
  	#messages = Message.query_as(:m).match("(c :Conversation)<-[:belong_to]-m").where("c.uuid = '#{self.uuid}'").order('m.time_in_coming DESC').pluck(:m)
    messages = Message.query_as(:m).match("(c :Conversation)<-[:belong_to]-m").where("c.uuid = '#{self.uuid}'").pluck(:m)
  end
end
