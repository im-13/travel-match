class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  #before_action :logged_in_user, only: [:create, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all.paginate(:page => params[:page], :per_page => 10, :order  => { created_at: :desc })
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  
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
    @CarrierwaveImage = CarrierwaveImage.create
    respond_to do |format|
      if @blog.save

        bloglink = IsAuthorOf.new(from_node: current_user, to_node: @blog)
        imagelink = HasAttached.new(from_node: @blog, to_node: @CarrierwaveImage)
        #commentlink = Has.new(from_node: @blog, to_node: @Comment)
        imagelink.save
        imagelink.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:content, :asset, :photo, :remove_photo, :remove_asset, :avatar, :avatar_remove)
    end
end
