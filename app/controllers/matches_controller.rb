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

  def specific_search_new
  end

  def specific_search_create
    user = current_user
    if !user.nil?
      return_call = false
      return_exp = ""
      username = user.email
      target_country = user.lives_in

      #@matches = User.query_as(:users).match("users-[:lives_in]->(country:Country)").where('country.name = "#{target_country.name}" AND users.email <> "#{username}" AND users.gender = "female"').proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')

      match_exp = ""
      where_exp = "users.email <> '#{username}'" #by default, user should not get his/herself in the match

      residence_select = true
      gender_selected = true

      if residence_select 
        match_exp << 'users-[:lives_in]->(country:Country)'
        where_exp << " AND country.name = '#{target_country.name}'"
      end

      if gender_selected
        gender_choice = 'female'
        where_exp << " AND users.gender = '#{gender_choice}'"
      end

      if has_visited_selected

        return_call = true
        match_exp << "<-[:lives_in]-(user2:User), (user2)-[:has_been_to]-(visitedList:Country)"

        user_visited_list = user.has_visited
        name_list = new Array()
        user_visited_list.each do |list_item|
          name_list << "#{list_item.neame}"
        end

        #convert the array into a string output
        array_string

        where_exp << " AND visitedList.name IN '#{array_string}'"
        return_exp = "user2, count(*) as strength ORDER BY strength DESC"
        
        #we need an order_by expression as well
        #working version of the match in literal query
        #match (user:User)-[:lives_in]->(c:Country)<-[:lives_in]-(user2:User), (user2)-[:has_been_to]-(visitedList:Country) where c.name = "United States" and visitedList.name IN ['Bosnia','Iraq','North Vietnam'] return user2, count(*) as strength ORDER BY strength DESC

        #************return examples, VERY NICE RETURN AS exmaple here***********
        #   self.class.query_as(:result).where("ID(result)" => self.neo_id).return("LABELS(result) as result_labels").first.result_labels.map(&:to_sym)
        #more return examples
        #start_q.query.return("COUNT(#{var}) AS count").first.count > 0

        #order_by(:strength)
      end

      if return_call 
         @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").return("#{return_exp}").proxy_as(User, user2).paginate(page: 1, per_page: 10)
      else
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
        @matches = reduce_by_age(@matches, 22, 35)
      end

    end
  end

  def create
    user = current_user #makes call to the session helper function which will return the session user
    if !user.nil?
      username = user.email
      #core::query
      #target_country = user.query_as(:n).match("n-[:lives_in]->(country:Country)").pluck(:country).firs
      target_country = user.lives_in
      user_birth = user.date_of_birth
      #once country is determined we can do many thing 
      #@matches = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{target_country.name}' AND n.email <> '#{username}'").proxy_as(User, :n).paginate(page: 1, per_page: 10, return: :'distinct n')
      @matches = User.all.as(:u).paginate(page: 1, per_page: 4, return: :'distinct u')
      #@matches = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{target_country.name}' AND n.email <> '#{username}'").proxy_as(User, :n).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct n')
      #@match = reduce_by_age(user, @match)
    end 
  end

end
