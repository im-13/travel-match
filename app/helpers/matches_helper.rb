module MatchesHelper

	def reduce_by_age(result, min_age, max_age)
		result.each do |result_item|
			temp_age = result_item.get_age 
			if temp_age.to_i > max_age 
				#open('myfile.out', 'a') { |f|
	            #  f.puts "first condition"
	            #}
				result.delete(result_item)
			elsif temp_age.to_i < min_age 
				result.delete(result_item)
			end
		end
		trim_ends(result, 0, min_age, max_age)
		trim_ends(result, 1, min_age, max_age)
		return result
	end

	def trim_ends(result, type, min_age, max_age)
		temp_item = ''
		if type == 0
			temp_item = result.first
		else
			temp_item = result.last
		end
		if temp_item
			temp_age = temp_item.get_age 
			if temp_age.to_i > max_age 
				result.delete(temp_item)
			elsif temp_age.to_i < min_age 
				result.delete(temp_item)
			end
		end
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
