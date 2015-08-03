class FollowsController0 < ApplicationController
  before_action :logged_in_user

  def create
  	user = User.find_by(uuid: params[:user_uuid])
  	rel = Follows.new(from_node: current_user, to_node: user)
	rel.save
	respond_to do |format|
      flash[:success] = "User added to your Favorites."
      format.html { redirect_to user }
    end
  end

  def destroy

  end
end