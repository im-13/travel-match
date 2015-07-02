class MatchesController < ApplicationController
  def new
    #new specific query page
  end

  def specific_search

  end

  def create

    targetCountry = "United States"
    #get all users from united states

    #all = User.all
    #len = all.length
    #render plain: "length : #{len}"
    #s = User.first
    #result = User.query_as(:n).match('n-[:lives_in]-o').return(o: :name)
    #clen = result.class
    #

    result = User.query_as(:n).match("n-[:LIVES_IN]->(country:Country)").where("country.name = 'United States' AND n.email <> 'hannyyanny@mailinator.com' ").pluck(:n)

    #querying the country united states is working 
    #result = Country.query_as(:n).match("n").where("n.name = 'United States'").pluck(:n)
    #result = Neo4j::Session.query("MATCH (n) WHERE ID(n) = {foobar} RETURN n", foobar: n.neo_id).n

    result_string = ""

    result.each do |user|
      result_string += "#{user.first_name}" + " #{user.last_name}" + " #{user.email}" + "\n"
    end
    #clen = result.class
    clen = result.length
    render plain: "result class : \n #{result_string}"

  end

end
