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

	def get_name_list(enum_list)
		name_list = Array.new
        enum_list.each do |list_item|
          name_list << "#{list_item.name}"
        end
        array_string = ""
        #convert the array into a string output
        if name_list.length > 0
          array_string = "['"+name_list.join("','")+"']"
        else
          array_string = "[]"
        end
        return array_string
	end

end
