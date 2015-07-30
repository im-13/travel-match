class BelongTo 
  include Neo4j::ActiveRel
  from_class Message
  to_class Conversation
  type 'belong_to'
end
