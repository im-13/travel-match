module BlogsHelper
	def blog_gravatar_for(blog, options = { size: 150 })
    gravatar_id = Digest::MD5::hexdigest(blog.user_email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: blog.user_name, class: "gravatar")
  end
end
