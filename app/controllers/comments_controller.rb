class CommentsController < ApplicationController
	#before_action :set_comment, only: [:show, :destroy]
	def create
		bid = params[:comment][:bid]
		value = params[:comment][:comment]
		@blog = Blog.find_by(uuid: bid)
		#@comment = @blog_comments.create(params[:comment].permit(:comment))
		@comment = Comment.new
		@blog.count_comments += 1
		@comment.comment = value
		@comment.user_name = current_user.full_name
		@comment.user_uuid = current_user.uuid
        @comment.user_gravatar_url = current_user.gravatar_url
        @comment.user_avatar_url = current_user.avatar_url 
		@comment.save
		@blog.save
		respond_to do |format|
			if @comment.save
				commentlink = Have.new(from_node: @blog, to_node: @comment)
	        	commentlink.save
	        	flash[:success] = "Comment entry was successfully created."
        		format.html { redirect_to @blog }
        		#format.json { render :show, status: :created, location: @blog }
        		format.json { render json: @comment, status: :created, location: @blog }
	    	else
        		format.html { render action: "new" }
        		format.json { render json: @comment.errors, status: :unprocessable_entity }
      		end
	    end   
	end

	def new
    	@comment = Comment.new
  	end

	def index
    	@comments = Comment.all.paginate(:page => params[:page], :per_page => 15, :order  => { created_at: :desc })
  	end

  	def destroy
  		@comment = Comment.find(params[:id])
  		@comment.destroy
	    respond_to do |format|
	      	flash[:success] = "Comment was successfully deleted."
	      	format.html { redirect_to travelblog_path  }
	    	format.json { head :no_content }
	    end
  	end

	def comment_params
      params.require(:comment).permit(:comment, :remove_comment, :user_name, :user_uuid, :avatar)
    end
end