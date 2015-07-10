require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index
    @matches
  end

  def specific_search

  end

  def create

    user = current_user #makes call to the session helper function which will return the session user
    if !user.nil?
      username = user.email
      #core::query
      #target_country = user.query_as(:n).match("n-[:lives_in]->(country:Country)").pluck(:country).firs

      target_country = user.lives_in(:l)

      user_birth = user.date_of_birth
      #once country is determined we can do many thing 
      @matches = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{target_country.name}' AND n.email <> '#{username}'").proxy_as(User, :n).paginate(page: 1, per_page: 10, order: :first_name, return: :'distinct n')
      
      #@match = reduce_by_age(user, @match)
                                                                                                                                                                                                    #  :page => params[:page] 
      if @matches
        flash.now[:success] = "TravelMatch found."
        #format.html { redirect_to mymatches_url} 
        #format.json { head :no_content }
        render "index"
      else
        flash[:danger] = "TravelMatch not found."
        #format.html { render :new }
      end
    end  
  end

end
