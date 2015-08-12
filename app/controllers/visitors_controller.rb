class VisitorsController < ApplicationController
before_action :logged_in_user, only: [:index]
	def index
		@session_user = current_user
		#match (n:User)-[rel:People_You_Viewed]->(m:User) where n.email = 'testuser1@mailinator.com' return  m, rel order by rel.time_viewed desc
		@visitors = @session_user.query_as(:user).match("(user:User)-[rel:People_You_Were_Viewed_By]->(m:User)").where("user.email = '#{@session_user.email}'").order('rel.time_viewed DESC').return(:m).proxy_as(User, :m).paginate(:page => params[:page], per_page: 10, return: :'m')
		#@visitors = @session_user.People_You_Were_Viewed_By.to_a
	end
end
