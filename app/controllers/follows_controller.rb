require 'neo4j-will_paginate_redux'
class FollowsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :destroy]

  def index
  	@session_user = current_user
    @followings = @session_user.query_as(:user).match("(user:User)-[rel:following]->(m:User)").where("user.email = '#{@session_user.email}'").order('rel.created_at DESC').return(:m).proxy_as(User, :m).paginate(:page => params[:page], per_page: 10, return: :'m')
    #@followings = @session_user.following.paginate(page: 1, per_page: 10)
    #@followings = @session_user.following.to_a
  end

  def create
    @user = User.find(params[:rid])
    @sess_user = current_user
    count = number_of_links( @sess_user, @user)
    if count == 0
      rel = Follow.new(from_node: @sess_user, to_node: @user)
      rel.follower_id = @sess_user.uuid
      rel.followed_id = @user.uuid
      rel.save
    end
    #respond_to do |format|
    #  format.js { redirect_to root_url }
    #end
    #redirect_to root_url
    render json: { status: "success" }
  end

  def destroy
  	@user = User.find(params[:rid])
    current_user.unfollow(@user)
    #redirect_to root_url
    render json: { status: "success" }
  end

  private
    def number_of_links( session_user, selected_user )
      rel = session_user.query_as(:cur_user).match('cur_user-[rel:following]->select_user').where(" select_user.uuid = '#{selected_user.uuid}'").pluck(:rel)
      if rel
        return rel.length
      else
        return 0
      end
    end

end
