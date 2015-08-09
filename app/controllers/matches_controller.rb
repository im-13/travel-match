require 'neo4j-will_paginate_redux'

class MatchesController < ApplicationController

  def new
    #new specific query page
  end

  def index
    @matches = process_selections
  end

  #selective match
  def selective_match
    country = get_country_name_from_code(params[:match][:country_of_residence_code_match])
    redirect_to url_for(:controller => :matches,
      :action => 'index',
      :check_box_country_of_residence_code_match => params[:check_box_country_of_residence_code_match],
      :check_box_age_match => params[:check_box_age_match],
      :age_from_match => params[:age_from_match],
      :age_to_match => params[:age_to_match],
      :check_box_gender_match => params[:check_box_gender_match],
      :gender_match => params[:gender_match],
      :check_box_country_to_visit_codes_match => params[:check_box_country_to_visit_codes_match],
      :check_box_country_visited_codes_match => params[:check_box_country_visited_codes_match],
      :country_of_residence_code_match => country
      )
  end

  def quick_match
    @matches = default_match
  end

end
