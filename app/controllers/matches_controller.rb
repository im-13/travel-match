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

      #@matches = User.query_as(:users).match("users-[:lives_in]->(country:Country)").where('country.name = "#{target_country.name}" AND users.email <> "#{username}" AND users.gender = "female"').proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')

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

        #if gender_select
        #  where_exp << " AND users.gender = '#{gender_choice}'"
        #end
      end

      #if want_to_visit_selected
      if params[:check_box_country_to_visit_codes_match] == '1'
        return_call = true
        non_default = true
        user_wish_list = user.want_to_visit
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
        user_visited_list = user.has_visited
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
        @matches = User.query_as(:users).match(user2: User).match("#{nonjoin_match_exp}").where("#{nonjoin_where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 10, return: :'distinct user2')
        non_default = true
      elsif residence_select
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, return: :'distinct users')
        non_default = true
      elsif gender_select
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
        non_default = true
      end

      #if not non default === (double negative) ---> if is default
      if !non_default
        if age_select
          @matches = User.as(:users).where("users.name <> '#{username}'").paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
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

=begin
      if non_default
        if !:age_from_match.nil? or !:age_to_match.nil?
          min_age = 18
          max_age = 200
          if :age_from_match >= 18
            min_age = :age_from_match.to_i
          end
          if :age_from_match <= 200
            max_age = :age_to_match.to_i
          end
          @matches = reduce_by_age(@matches, min_age, max_age)
        end #else do nothing
        #check age after all the query have ran
      else
        @match = default_match
        if :age_from_match.length >= 1 or :age_to_match.length >= 1
          min_age = 18
          max_age = 200
          if :age_from_match.length >= 1 and :age_from_match.to_i >= 18
            min_age = :age_from_match.to_i
          end
          if :age_from_match.length >= 1 and :age_from_match.to_i <= 200
            min_age = :age_to_match.to_i
          end
          @matches = reduce_by_age(@matches, min_age, max_age)
        end
      end
=end

=begin
      if join_call #if join call is true
        second_query = User.query_as(:users).match(user2: User).match("#{join_match_exp}").where("#{join_where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2)

        join_query =  User.query_as(:users).match(user2: User).match("#{nonjoin_match_exp}").where("#{nonjoin_where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).union_cypher(second_query)
     
        #@matches = Neo4j::Session.query(join_query)

        #.proxy_as(User, :user2).paginate(page: 1, per_page: 10, return: :'distinct user2')
        
        #render plain: join_query
        #id_list = ""
        #@matches.each do |match|
        #  id_list << ", "+match[:user2].email
        #end

        #render plain: id_list

      elsif return_call #if one of the visted or want to visit selections has been picked
        @matches = User.query_as(:users).match(user2: User).match("#{nonjoin_match_exp}").where("#{nonjoin_where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 10, return: :'distinct user2')

      elsif residence_select #query base 
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
      else
        @matches = User.all
      end
      #need to call the age
=end

      #@matches.paginate(page: 1, per_page:10)

      #working version
      #@matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')

      render 'index'
=begin
      if return_call
        if order_call 
         #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order(strength: :desc).return(:user2).proxy_as(User, :user2)
         #@matches.paginate(page: 1, per_page:10)

         @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :user2).paginate(page: 1, per_page:10, return: :'distinct user2';

         #@matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page:10)
         
         #@matches = User.query("MATCH (users:`User`), (user2:`User`), users-[:lives_in]->(country:Country)<-[:lives_in]-(user2:User), (user2)-[:has_been_to]->(visitedList:Country) WHERE (users.email <> 'testuser1@mailinator.com' AND country.name = 'United States' AND users.gender = 'female' AND visitedList.name IN ['North Korea','Vietnam','Iraq','Bosnia']) with user2, count(user2) as strength order by strength desc return user2").proxy_as(User, :users).paginate(page: 1, per_page: 10)
         #.proxy_as(User, :user2).paginate(page: 1, per_page: 10)
        end
      else
        @matches = User.query_as(:users).match("#{match_exp}").where("#{where_exp}").proxy_as(User, :users).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct users')
        @matches = reduce_by_age(@matches, 22, 35)
      end

      #full cypher query for selective search

      #MATCH (users:`User`), (user2:`User`), users-[:lives_in]->(country:Country)<-[:lives_in]-(user2:User), (user2)-[:has_been_to]->(visitedList:Country) WHERE (users.email <> 'testuser1@mailinator.com' AND country.name = 'United States' AND users.gender = 'female' AND visitedList.name IN ['North Korea','Vietnam','Iraq','Bosnia'])  with user2, count(user2) as strength order by strength desc return user2 UNION MATCH (users:`User`), (user2:`User`), users-[:lives_in]->(country:Country)<-[:lives_in]-(user3:User), (user2)-[:wants_to_go_to]->(wish_list:Country) WHERE (wish_list.name IN ['France','Belgium','Germany']) with user2, count(user2) as strength order by strength desc return user2

=end
    end
  end

  def default_match 
    #this search will be base on user's residency and their desired destination
     user = current_user
    if !user.nil?
      username = user.email
      target_country = user.lives_in 
      user_wish_list = user.want_to_visit
      array_string = get_name_list( user_wish_list )
      match_exp = "(user)-[:lives_in]->(country:Country)<-[lives_in]-(user2),(user2)-[:wants_to_go_to]->(wish_list:Country)"
      where_exp = "country.name = '#{target_country.name}' AND wish_list.name IN #{array_string} AND user2.email <> '#{username}'"
      @matches = User.query_as(:users).match(user2: User).match("#{match_exp}").where("#{where_exp}").with(:user2, strength: 'count(user2)').order('strength DESC').return(:user2).proxy_as(User, :user2).paginate(page: 1, per_page: 10, return: :'distinct user2')
    end
  end

end

#author = Blog.query_as(:blog).match(author:User).where("blog.content = match_exp").optional_match("b<-[:is_author_of]-(author:User)").proxy_as(User, :author)




