require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index
    @matches
  end

  #selective match
  def create
    user = current_user
    if !user.nil?
      return_call = false
      join_call = false
      non_default = false
      username = user.email
      target_country = user.lives_in
      gender_choice = ""

      match_exp = ""
      where_exp = "users.email <> '#{username}'" #by default, user should not get his/herself in the match

      nonjoin_match_exp = ""
      nonjoin_where_exp = ""
      join_match_exp = ""
      join_where_exp = ""

      residence_select = false
      gender_select = false
      has_visited_select = false
      want_to_visit_select = false
      age_select = false
      min_age = 18
      max_age = 100

      if params[:check_box_age_match] == '1'
        age_select = true

        from = params[:age_from_match].to_i
        to = params[:age_to_match].to_i
        if from > 18
          min_age = from
        end
        if to < 100
          max_age = to
        end
      end

      #if gender_selected
      if params[:check_box_gender_match] == '1'
        gender_select = true
        non_default = true
        if params[:gender_match] == 'female'
          gender_choice = "female"
        else 
          gender_choice = "male"
        end
        where_exp << " AND users.gender = '#{gender_choice}'"
      end

      #if residence_select
      if params[:check_box_country_of_residence_code_match] == '1'
        #open('myfile.out', 'a') { |f|
        # f.puts "checking residence code "
        #}
        residence_select = true
        non_default = true
        match_exp << 'users-[:lives_in]->(country:Country)'
        where_exp << " AND country.name = '#{target_country.name}'"

      end

      #if want_to_visit_selected
      if params[:check_box_country_to_visit_codes_match] == '1'
        return_call = true
        non_default = true
        user_wish_list = user.wants_to_go_to
        array_string = get_name_list( user_wish_list )
        if residence_select
          nonjoin_match_exp = match_exp + "<-[:lives_in]-(user2), (user2)-[:wants_to_go_to]->(wish_list:Country)"
        else
          nonjoin_match_exp = match_exp + " (user2)-[:wants_to_go_to]->(wish_list:Country)"
        end
        if where_exp.length > 0
          where_exp << " AND "
        end
        nonjoin_where_exp = where_exp + " wish_list.name IN #{array_string} AND user2.email <> '#{username}'"
        if gender_select
          nonjoin_where_exp << " AND user2.gender = '#{gender_choice}'"
        end
      elsif params[:check_box_country_visited_codes_match] == '1'
        return_call = true
        non_default = true
        user_visited_list = user.has_been_to
        array_string = get_name_list( user_visited_list )
        if residence_select 
          nonjoin_match_exp = match_exp + "<-[:lives_in]-(user2), (user2)-[:has_been_to]->(visitedList:Country)"
        else
          nonjoin_match_exp = match_exp + " (user2)-[:has_been_to]->(visitedList:Country)"
        end
        if where_exp.length > 0
          where_exp << " AND "
        end
        nonjoin_where_exp = where_exp + " visitedList.name IN #{array_string} AND user2.email <> '#{username}'"
        if gender_select
          nonjoin_where_exp << " AND user2.gender = '#{gender_choice}'"
        end
      end

      if return_call #this means that one of the visited or wants to visit match has been called
        @matches = User.query_as(:users).match(user2: User).match("#{nonjoin_match_exp}").where("#{nonjoin_where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 2, return: :'distinct user2')
        non_default = true
      elsif residence_select
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 2, return: :'distinct users')
        non_default = true
      elsif gender_select
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 2, order: :first_name, return: :'distinct users')
        non_default = true
      end

      #if not non default === (double negative) ---> if is default
      if !non_default
        if age_select
          @matches = User.as(:users).where("users.name <> '#{username}'").paginate(page: 1, per_page: 2, order: :first_name, return: :'distinct users')
          @matches = reduce_by_age(@matches, min_age, max_age)
        else
          @matches = default_match
        end
      else
        if age_select
          #open('myfile.out', 'a') { |f|
          #  f.puts "minimum age class:"+min_age.class.to_s+" max_age:"+max_age.class.to_s
          #}
          @matches = reduce_by_age(@matches, min_age, max_age)
        end
      end

      render 'index'
    end
  end

  def default
    @matches = default_match
    render 'index'
  end

end
