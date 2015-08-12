class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :create, :update, :destroy, :destroy_comment]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all.paginate(:page => params[:page], :per_page => 10, :order  => { created_at: :desc })
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog = Blog.find(params[:id])
    #@comments = Comment.all.paginate(:page => params[:page], :per_page => 10, :order  => { created_at: :desc })
    #@comments = @blog.have
    @comments = Comment.query_as(:c).match("(blog:Blog)-[:have]->(c)").where("blog.uuid = '#{@blog.uuid}'").proxy_as(Comment, :c)#.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc },return: :'distinct c’)
    #@count_com = @comments.length.to_s
    @blog.count_comments = @comments.length.to_i
    
    @carrierwave_images = CarrierwaveImage.query_as(:i).match("(blog:Blog)-[:have]->(i)").where("blog.uuid = '#{@blog.uuid}'").proxy_as(CarrierwaveImage, :i)#.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc },return: :'distinct c’)
    #@blog.count_photos = @carrierwave_image.length.to_i
    
    @blog.save
    puts @count_com
    #open('myfile.out', 'a'){ |f|
    #  f.puts " number of comments:"+@comments.length.to_s 
    #}
    @new_comment = Comment.new
    @new_image = CarrierwaveImage.new
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
    #@carrierwave_images = CarrierwaveImage.query_as(:i).match("(blog:Blog)-[:have]->(i)").where("blog.uuid = '#{@blog.uuid}'").proxy_as(CarrierwaveImage, :i)#.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc },return: :'distinct c’)
    #@blog.count_photos = @carrierwave_images.length.to_i
    #@blog.save

    #@new_image = CarrierwaveImage.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)
    @blog.user_name = current_user.full_name
    @blog.user_uuid = current_user.uuid
    @blog.user_gravatar_url = current_user.gravatar_url 
    @blog.user_email = current_user.email 
    @comment = Comment.new
   # @carrierwave_image = CarrierwaveImage.new
   # @carrierwave_images = CarrierwaveImage.query_as(:i).match("(blog:Blog)-[:have]->(i)").where("blog.uuid = '#{@blog.uuid}'").proxy_as(CarrierwaveImage, :i)#.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc },return: :'distinct c’)
   # @blog.count_photos = @carrierwave_images.length.to_i

   # @new_image = CarrierwaveImage.new
    #CarrierwaveImage.create
    #@Comment = Comment.create
    #Comment.create
    respond_to do |format|
      if @blog.save

        bloglink = IsAuthorOf.new(from_node: current_user, to_node: @blog)
        #imagelink = HasAttached.new(from_node: @blog, to_node: @CarrierwaveImage)
        #commentlink = Has.new(from_node: @comment, to_node: @blog)
        #imagelink.save
        #commentlink.save
        bloglink.save

        flash[:success] = "Blog entry was successfully created."
        format.html { redirect_to @blog }
        #format.html { redirect_to current_user }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        flash[:success] = "Blog entry was successfully created."
        format.html { redirect_to @blog }
        #format.html { redirect_to current_user }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      flash[:success] = "Blog entry was successfully destroyed."
      format.html { redirect_to blogs_url }
      #format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end

  def destroy_comment
    @comment.destroy
    respond_to do |format|
      flash[:success] = "Comment was successfully destroyed."
      format.html { redirect_to blogs_url }
      #format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :comment, :photo, :content, :asset, :photo, :photo2, :photo3, :remove_photo, :remove_photo2, :remove_photo3,:remove_asset, :avatar, :avatar_remove, :remove_comment)
    end
end
