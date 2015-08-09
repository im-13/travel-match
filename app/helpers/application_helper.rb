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

	def avatar_profile_link(user, image_options={ }, html_options={})
		avatar_url = user.avatar? ? user.avatar_url(:thumb) : user.gravatar_url
		link_to(image_tag(avatar_url, image_options), profile_path(user.first_name), html_options)
	end

	def small_avatar_profile_link(user, image_options={ }, html_options={})
		avatar_url = user.avatar? ? user.avatar_url(:small) : user.gravatar_url
		link_to(image_tag(avatar_url, image_options), profile_path(user.first_name), html_options)
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

	def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

end
