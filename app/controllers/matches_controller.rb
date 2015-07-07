class MatchesController < ApplicationController
  def new
    #new specific query page
  end

  def specific_search

  end

  def create
    user = current_user #makes call to the session helper function which will return the session user
    if !user.nil?
      username = user.email
      target_country = user.query_as(:n).match("n-[:lives_in]->(country:Country)").pluck(:country).first 
      user_birth = user.date_of_birth
      #once country is determined we can do many thing 
      result = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{target_country.name}' AND n.email <> '#{username}'").pluck(:n)
      
      result = reduce_by_age(user, result)

      result_string = ""
      result.each do |user|
        result_string += "#{user.first_name}" + " #{user.last_name}" + ": #{user.email} " + " : #{user.get_age} yrs old \n"
      end

      #clen = result.class
      clen = result.length
      render plain: "result class : \n #{result_string}"
      
    end
  end

end
