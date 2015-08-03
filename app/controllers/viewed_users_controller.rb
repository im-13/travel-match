class ViewedUsersController < ApplicationController

	def index
		@session_user = current_user
		@viewed_users = @session_user.People_You_Viewed.to_a
	end
end
