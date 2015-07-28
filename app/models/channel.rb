class Channel 
  include Neo4j::ActiveRel
  from_class User
  to_class Conversation
  type 'channel_to'
end
