module ApplicationHelper
	# Returns the full title on a per-page basis.
	def full_title(page_title = '')
	    base_title = "TravelMatch"
	    if page_title.empty?
	      base_title
	    else
	      page_title + " | " + base_title
	    end
	end

	def clean_name( raw )
		start_index = get_start_index( raw )
		end_index = get_end_index( raw )
		#open('myfile.out', 'a') { |f|
        #	f.puts "original:#{raw} start index: "+start_index.to_s + " end index: "+end_index.to_s
      	#}
		return raw[(start_index)..(end_index)]
	end

	def get_start_index( raw )
		start_index = 0
		lowercase = raw.downcase
		lowercase.each_char do |i|
			if /[a-z]/.match(i)
				break
			else
				start_index += 1
			end
		end
		return start_index
	end

	def get_end_index( raw )
		end_index = raw.length-1
		lowercase = raw.downcase
		for i in end_index..0
			if /[a-z]/.match(lowercase[i])
				break
			else
				end_index -= 1
			end
		end
		return end_index
	end

end
