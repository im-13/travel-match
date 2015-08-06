class ViewedUsersController < ApplicationController

	def index
		@session_user = current_user
		@viewed_users = @session_user.query_as(:user).match("(user:User)-[rel:People_You_Viewed]->(m:User)").where("user.email = '#{@session_user.email}'").order('rel.time_viewed DESC').return(:m).proxy_as(User, :m).paginate(page: 1, per_page: 10, return: :'m')
		#@viewed_users = @session_user.People_You_Viewed.to_a
	end
end
