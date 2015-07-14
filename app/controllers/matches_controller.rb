require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index
    if @matches
      @matches
    else
      @match = specific_search_create
    end
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


      if :check_box_country_of_residence_code_match 
        match_exp << 'users-[:lives_in]->(country:Country)'
        where_exp << " AND country.name = '#{target_country.name}'"
      end

      if :check_box_gender_match
        gender_choice = :gender_match
        where_exp << " AND users.gender = '#{gender_choice}'"
      end

      if :check_box_country_visited_codes_match

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

      if return_call 
        if order_call 
         #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").order(strength: :desc).with(strength: 'count(user2) ').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page:10)

         @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").order(strength: :desc).with(strength: 'count(user2)').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page:10)

         #.proxy_as(User, :user2).paginate(page: 1, per_page: 10)
        end
      else
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
        @matches = reduce_by_age(@matches, 22, 35)
      end

    end
  end

end
