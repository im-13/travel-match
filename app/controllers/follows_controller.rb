require 'neo4j-will_paginate_redux'
class FollowsController < ApplicationController
  before_action :logged_in_user

  def index
  	@session_user = current_user
    #@followings = @session_user.following.paginate(page: 1, per_page: 10)
    @followings = @session_user.following.to_a
  end

  def create
    @user = User.find(params[:rid])
    current_user.follow(@user)

    #respond_to do |format|
    #  format.js { redirect_to root_url }
    #end
    #redirect_to root_url
    render json: { status: "success" }
  end

  def destroy
  	@user = User.find(params[:rid])
  	puts current_user.email
    current_user.unfollow(@user)
    #redirect_to root_url
    render json: { status: "success" }
  end

end
