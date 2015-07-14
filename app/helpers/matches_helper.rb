module MatchesHelper

	def reduce_by_age(result, min_age, max_age)
		result.each do |result_item|
			temp_age = result_item.get_age 
			if temp_age > max_age 
				result.delete(result_item)
			elsif temp_age < min_age 
				result.delete(result_item)
			end
		end

		return result
	end
end
