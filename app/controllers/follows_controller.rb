class FollowsController < ApplicationController
  before_action :logged_in_user

  def index
  	@favorite_users 
  end

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to users_url
  end

  def destroy
  	@user = User.find(params[:followed_id])
  	puts current_user.email
    current_user.unfollow(@user)
    redirect_to users_url
  end

end
