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

  def establish_user_connection( viewed_user )
    session_user = current_user
    #all users viewed
    users_viewed = session_user.People_You_Viewed.to_a 
    #all users the current user has viewed
    if users_viewed.size < 10
      #need to check if the connection to the target viewed_user already exist in the viewed array
      if users_viewed.include? viewed_user
        rel = session_user.query_as(:sess_user).match('sess_user-[rel:People_You_Viewed]->v_user').where(" v_user.email = '#{viewed_user.email}'").pluck(:rel).first
        rel.stamp
        rel.save
      else #not an already viewed user
        rel_instance = Viewed.new
        rel_instance.from_node = session_user
        rel_instance.to_node = viewed_user
        rel_instance.save
      end
    else #threshold reached
      viewed_association = session_user.query_as(:sess_user).match('sess_user-[rel:Viewed]->v_user').order('rel.time_viewed DESC').return(:rel).to_a #
      relation_to_be_removed = viewed_association.pop
      if relation_to_be_removed
        relation_to_be_removed.destroy #destroys the relationship
      end

      rel_instance = Viewed.new
      rel_instance.from_node = session_user
      rel_instance.to_node = viewed_user
      rel_instance.save
    end

    open('myfile.out', 'a') { |f|
      f.puts "viewed_user name:"+viewed_user.full_name
    }
    #the person you've viewed, should be able to see who's viewed them
    user_viewed_by = viewed_user.People_You_Were_Viewed_By.to_a
    if user_viewed_by.size < 10
      if user_viewed_by.include? session_user
        rel = viewed_user.query_as(:v_user).match('v_user-[rel:People_You_Were_Viewed_By]->sess_user').where(" sess_user.email = '#{session_user.email}'").pluck(:rel).first
        rel.stamp
        rel.save
      else #not an already viewed user
        rel_instance = ViewedBy.new
        rel_instance.from_node = viewed_user
        rel_instance.to_node = session_user
        rel_instance.save
      end
    else
      viewed_by_association = viewed_user.query_as(:v_user).match('v_user-[rel:People_You_Were_Viewed_By]->sess_user').order('rel.time_viewed DESC').return(:rel).to_a #
      relation_to_be_removed = viewed_by_association.pop
      if relation_to_be_removed
        relation_to_be_removed.destroy #destroys the relationship
      end

      rel_instance = ViewedBy.new
      rel_instance.from_node = viewed_user
      rel_instance.to_node = session_user
      rel_instance.save
    end
  end

end
