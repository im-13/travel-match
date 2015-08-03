class VisitorsController < ApplicationController

	def index
		@session_user = current_user
		@visitors = @session_user.People_You_Were_Viewed_By.to_a
	end
end
