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

	def default_match 
	    #this search will be base on user's residency and their desired destination
	    user = current_user
	    if !user.nil?
	      username = user.email
	      target_country = user.lives_in 
	      user_wish_list = user.wants_to_go_to
	      array_string = get_name_list( user_wish_list )
	      match_exp = "(user)-[:lives_in]->(country:Country)<-[lives_in]-(user2),(user2)-[:wants_to_go_to]->(wish_list:Country) "
	      where_exp = "country.name = '#{target_country.name}' AND wish_list.name IN #{array_string} AND user2.email <> '#{username}'"
	      #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 1, return: :'distinct user2')
	      @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(:page => params[:page], per_page: 1, return: :'distinct user2')
	      if @matches.length < 20 #two page minimum
	        return @matches = default_back_up( @matches, user )
	      else
	        return @matches
	      end
	    end
	end

	# manual performance of a union join, not the most efficient way of doing it but it will do for now
	# 2 parameters
	# current_results is a WillPaginate::Collection object
	# cur_user is a query user  
	def default_back_up( current_results, cur_user )
		#the the current_results number of items is less than 20 is the reason why we're in here
		username = cur_user.email
		target_country = cur_user.lives_in 
		user_traveled_list = cur_user.has_been_to
		array_string = get_name_list( user_traveled_list )
		match_exp = "(user)-[:lives_in]->(country:Country)<-[lives_in]-(user2),(user2)-[:has_been_to]->(traveled_list:Country) "
		where_exp = "country.name = '#{target_country.name}' AND traveled_list.name IN #{array_string} AND user2.email <> '#{username}'"
		back_up_matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").return('user2.uuid').to_a

		current_results = current_results.to_a
		id_list = Array.new

		current_results.each do |current_item|
		  id_list << current_item.uuid
		end

		current_results.concat(back_up_matches)

		where_exp = "users.email <> '#{username}'"
		if current_results.length < 10
		  default = User.query_as(:users).where("#{where_exp}").proxy_as(User, :users).paginate(:page => params[:page], per_page: 1, return: :'distinct users')
		  return default
		else
		  where_exp << "AND users.uuid IN #{id_list}"
		  join_match = User.query_as(:users).where("#{where_exp}").proxy_as(User, :users).paginate(:page => params[:page], per_page: 1, return: :'distinct users')
		  return join_match
		end
	end

end
