class Message 
  include Neo4j::ActiveNode
	before_save :stamp
	property :time_in_coming, type: String
	property :user_id, type: String
	property :body, type: String

	has_one :out, :belong_to, model_class: Conversation, rel_class: BelongTo

	def stamp
  		time = Time.now.to_s
		time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
		self.time_in_coming = time
  	end
end
