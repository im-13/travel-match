class CommentsController < ApplicationController
	def create
		@blog = Blog.find(params[:content])
		@comment = @blog.comments.create(params[:comment].permit(:comment))
		@comment.user_name = current_user.user_name

		if @comment.save
			redirect_to blog_path(@blog)
		else
			flash.now[:danger] = "error"
		end
	end
end
