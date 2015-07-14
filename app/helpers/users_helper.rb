module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 150 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.first_name, class: "gravatar")
  end

  #def avatar_for(user, options = { size: 150 })
  #  gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #  size = options[:size]
  #  asset_url = user.AddAvatarToUser? ? user.asset.url : user.gravatar_url
  #  image_tag(asset_url, alt: user.first_name, class: "asset")
  #end

end
