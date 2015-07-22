module CountriesHelper

  def country_check( countryArr )
    ret = true
    index = 0
    countryArr.each do |country|
      country_str = clean_name(country)
      #debugging
      #open('myfile.out', 'a') { |f|
      #  f.puts country_str
      #}
      country = ISO3166::Country.find_country_by_name(country_str)
      if country.nil?
        ret = false
        break
      else
        if /,/.match(country.name) 
          countryArr[index] = country_str
        else
          countryArr[index] = country.name
        end
      end
      index += 1
    end
    return ret
  end

	def create_if_not_found ( countryName )
		countryFound = Country.find_by( name: "#{countryName}" )
        if countryFound
          countryFound
        else
          countrycreated = Country.new
          countrycreated.name = countryName
          countrycreated.code = countrycreated.set_code
          countrycreated.save
          countrycreated
        end
	end

  #the goal of this function is the decide which country relationships to add and which to delete
  # sample call make_decision @user visitedArr 2
  def make_decision ( user, new_input_list, rel_type)
    #first get the list of countries relate to each user by the type
    country_by_relation = ""
    if rel_type == 1 #lives_in
      #use the following
      country_by_relation = user.query_as(:s).match('s-[rel1:`lives_in`]->n2').pluck(:n2)
    elsif rel_type == 2 #has been to
      country_by_relation = user.query_as(:s).match('s-[rel1:`has_been_to`]->n2').pluck(:n2)
    elsif rel_type == 3 #wants to go to
      country_by_relation = user.query_as(:s).match('s-[rel1:`wants_to_go_to`]->n2').pluck(:n2)
    end

    #list of countries to create the relationship with
    list_to_create = Array.new
    #list of countries to delete the relationship with

    country_by_relation = country_by_relation.to_a
    new_input_list.each do |target_country| #runs through the list
      ret = is_in_country_nodes(target_country, country_by_relation)
      if ret.nil? #ret is not set, meaning the country in the current index of the search list does not exist, we add it
        ret = create_if_not_found(target_country) #create the country if does not exist else get the country
        list_to_create << ret
      end
    end 

    if !country_by_relation.nil?
      delete_relationship(user, country_by_relation, rel_type)
    end

    if !list_to_create.nil?
      add_relationship(user, list_to_create, rel_type)
    end
    return user
  end

  def is_in_country_nodes ( target_country, nodeList )
    if !nodeList.nil?
      nodeList.each do | node |
        if node.name == target_country
          nodeList.delete(node)
          return node
        end
      end
    end
    return nil 
  end

  def delete_relationship ( user, country_list, rel_type )
    rel_instance = get_rel_name rel_type
    country_list.each do |country_node|
      rel = user.query_as(:s).match("s-[rel1:#{rel_instance}]->n2").where( "n2.name = '#{country_node.name}'").pluck(:rel1).to_a
      rel.each do |r|
        r.destroy
      end      
    end
  end 

  #all new updates to add in a list inside of the countries list, the delete function will delete all the relations one at a time
  def add_relationship ( user , country_list, rel_type )
    country_list.each do |country_node|
      rel_instance = get_rel_instance rel_type
      rel_instance.from_node = user
      rel_instance.to_node = country_node
      rel_instance.save
    end
  end

  def get_rel_instance ( rel_type )
    if rel_type == 1 #lives_in
      return LivesIn.new
    elsif rel_type == 2 #wants_to_go_to
      return HasBeenTo.new
    elsif rel_type == 3 #has_been_to
      return WantsToGoTo.new
    end
  end 

  def get_rel_name ( rel_type ) 
    if rel_type == 1 #lives_in
      return "lives_in"
    elsif rel_type == 2 #wants_to_go_to
      return "has_been_to"
    elsif rel_type == 3 #has_been_to
      return "wants_to_go_to"
    end
  end

end
