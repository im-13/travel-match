require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController
  def new
    #new specific query page
  end

  def index
    @matches = @match.paginate(:page => params[:page], :per_page => 10, order: :first_name)
  end

  def specific_search

  end

  def create

    respond_to do |format|

    targetCountry = "United States"
    #get all users from united states

    #all = User.all
    #len = all.length
    #render plain: "length : #{len}"
    #s = User.first
    #result = User.query_as(:n).match('n-[:lives_in]-o').return(o: :name)
    #clen = result.class
    #

    username = "hannyan@bmobilized.com"

    @match = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = 'United States' AND n.email <> 'test'").pluck(:n)

    #querying the country united states is working 
    #result = Country.query_as(:n).match("n").where("n.name = 'United States'").pluck(:n)
    #result = Neo4j::Session.query("MATCH (n) WHERE ID(n) = {foobar} RETURN n", foobar: n.neo_id).n

    
    if @match
        flash[:success] = "TravelMatch found."
        format.html { redirect_to mymatches_url} 
        format.json { head :no_content }
      else
        flash[:danger] = "TravelMatch not found."
        format.html { render :new }
      end



    end
  end

end
