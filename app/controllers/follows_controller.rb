class FollowsController < ApplicationController
  before_action :logged_in_user

  def index
  	@favorite_users 
  end

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.js { redirect_to root_url }
    end
    #redirect_to root_url
  end

  def destroy
  	@user = User.find(params[:followed_id])
  	puts current_user.email
    current_user.unfollow(@user)
    redirect_to root_url
  end

end
