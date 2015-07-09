module MatchesHelper

	def reduce_by_age(user, result)
		age = user.get_age
		max_age = age+7
		min_age = age-7
		result.each do |result_item|
			temp_age = result_item.get_age 
			if temp_age > max_age or temp_age < min_age 
				result.delete(result_item)
			end
		end
		return result
	end
end
