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
end
