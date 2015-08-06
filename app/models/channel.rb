class Channel 
  include Neo4j::ActiveRel
  from_class User
  to_class Conversation
  type 'channel_to'

  property :time_viewed, type: Date

  def stamp
    time = Time.now.to_s
    time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
    self.time_viewed = time
  end
end
