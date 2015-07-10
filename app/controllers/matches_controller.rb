require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index

    @matches

    #@users = User.all.paginate(:page => params[:page], :per_page => 10, order: :first_name)
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
      @matches = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{target_country.name}' AND n.email <> '#{username}'").pluck(:n)
      
      #@match = reduce_by_age(user, @match)

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
