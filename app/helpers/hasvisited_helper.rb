module HasvisitedHelper

	#add a time stamped message to the comment section in a hasvisited country
	def add_comment ( relation_node, comment)
		time_now = Time.now.to_s
		savemessage = "#{time_now} : #{comment}" 
		relation_node.comment << savemessage
	end

end
