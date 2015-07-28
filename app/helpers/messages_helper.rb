module MessagesHelper
	def self_or_other( message )
		message.user_id == current_user.uuid ? "self" : "other"
	end

	def message_interlocutor( message )
		sender = User.find_by(uuid: message.user_id)
	end
end
