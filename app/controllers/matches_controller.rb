require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index
    @matches
=begin
    if @matches
      @matches
    else
      @match = create
    end
=end
  end

  def create
    user = current_user
    if !user.nil?
      return_call = false
      order_call = false
      return_exp = ""
      username = user.email
      target_country = user.lives_in

      #@matches = User.query_as(:users).match("users-[:lives_in]->(country:Country)").where('country.name = "#{target_country.name}" AND users.email <> "#{username}" AND users.gender = "female"').proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')

      match_exp = ""
      where_exp = "users.email <> '#{username}'" #by default, user should not get his/herself in the match
      order_exp = ""
      return_exp = ""

      residence_select = true
      gender_selected = true
      has_visited_selected = true


      #if :check_box_country_of_residence_code_match 
      if residence_select
        match_exp << 'users-[:lives_in]->(country:Country)'
        where_exp << " AND country.name = '#{target_country.name}'"
      end

      #if :check_box_gender_match
      if gender_selected 
        gender_choice = "female"
        where_exp << " AND users.gender = '#{gender_choice}'"
      end

      #if :check_box_country_visited_codes_match
      if has_visited_selected
        return_call = true
        order_call = true
        match_exp << "<-[:lives_in]-(user2:User), (user2)-[:has_been_to]-(visitedList:Country)"

        user_visited_list = user.has_visited
        name_list = Array.new
        user_visited_list.each do |list_item|
          name_list << "#{list_item.name}"
        end

        #convert the array into a string output
        if name_list.length > 0
          array_string = "['"+name_list.join("','")+"']"
        else
          array_string = "[]"
        end

        where_exp << " AND visitedList.name IN #{array_string}"
        return_exp = " user2, count(*) as strength"
        order_exp = " ORDER BY strength DESC"
      end

      @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 10, return: :'distinct user2')
      #@matches.paginate(page: 1, per_page:10)

         #working version
      #@matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')

      render 'index'
=begin
      if return_call
        if order_call 
         #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order(strength: :desc).return(:user2).proxy_as(User, :user2)
         #@matches.paginate(page: 1, per_page:10)

         @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :user2).paginate(page: 1, per_page:10, return: :'distinct user2')

         

         #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page:10)
         
         #@matches = User.query("MATCH (users:`User`), (user2:`User`), users-[:lives_in]->(country:Country)<-[:lives_in]-(user2:User), (user2)-[:has_been_to]-(visitedList:Country) WHERE (users.email <> 'testuser1@mailinator.com' AND country.name = 'United States' AND users.gender = 'female' AND visitedList.name IN ['North Korea','Vietnam','Iraq','Bosnia']) with user2, count(user2) as strength order by strength desc return user2").proxy_as(User, :users).paginate(page: 1, per_page: 10)
         #.proxy_as(User, :user2).paginate(page: 1, per_page: 10)
        end
      else
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
        @matches = reduce_by_age(@matches, 22, 35)
      end
=end
    end
  end

end
