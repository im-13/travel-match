class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 10, order: :first_name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @blog = Blog.new
    @blog.user_name = @user.full_name
    @blog.user_uuid = @user.uuid
    @blog.user_gravatar_url = @user.gravatar_url 
    @blog.user_email = @user.email 
    #@CarrierwaveImage = CarrierwaveImage.create

    #if not the session user
    if !current_user?(@user)
      #establish a connection with the session user
      establish_user_connection(@user) #people you've viewed, and someone sees that you viewed them
    end

    @user_blog = Blog.query_as(:n).match("n").where("n.user_uuid = '#{@user.uuid}'").proxy_as(Blog, :n).paginate(:page => params[:page], :per_page => 5, :order => { created_at: :desc }, return: :'distinct n')
    @user_country_of_residence = @user.lives_in(:l)
    @user_matches = User.query_as(:n).match("n-[:lives_in]->(country:Country)").where("country.name = '#{@user_country_of_residence.name}' AND n.email <> '#{@user.email}'").proxy_as(User, :n).paginate(:page => params[:page], :per_page => 5, order: :first_name, return: :'distinct n')
  end

  def show_my_blog
    @user = current_user
    @blog = Blog.new
    @blog.user_name = @user.full_name
    @blog.user_uuid = @user.uuid
    @blog.user_gravatar_url = @user.gravatar_url 
    @blog.user_email = @user.email 
    @CarrierwaveImage = CarrierwaveImage.create
    @user_blog = Blog.query_as(:n).match("n").where("n.user_uuid = '#{@user.uuid}'").proxy_as(Blog, :n).paginate(:page => params[:page], :per_page => 2, :order => { created_at: :desc }, return: :'distinct n')
  end


  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    # get user's country_of_residence, 2 arrays of user's countries, 
    # array of hobbies
  end

  # POST /users
  # POST /users.jsonp
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        country = create_if_not_found @user.country_of_residence
        #we have the country
        rel = LivesIn.new(from_node: @user, to_node: country)
        #country.lives_in << @user 
        rel.save

        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        format.html { redirect_to root_url }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      @user = User.find(params[:id])
      if @user.update(user_params)

        #updating country of residence
=begin
        country = create_if_not_found @user.country_of_residence
        rel = LivesIn.new(from_node: @user, to_node: country)
        rel.save
=end        
        if params[:user][:country_of_residence_code]
          country_reside = @user.country_of_residence
          resideArr = country_reside.split(",")
          make_decision(@user, resideArr, 1)
        end

        if params[:user][:country_visited]
          #we need to accumulate the country_visited somehow
          visited = params[:user][:country_visited] 
          visitedArr = visited.split(",")
          if country_check(visitedArr)
            make_decision(@user, visitedArr, 2)
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end

        if params[:user][:country_to_visit]
          tovisit = params[:user][:country_to_visit] 
          tovisitArr = tovisit.split(",")
          if country_check(tovisitArr)
            make_decision(@user, tovisitArr, 3)
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end

        flash[:success] = "Profile was successfully updated."
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      flash[:success] = "User was successfully deleted."
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth, :gender,
                                  :country_of_residence_code, :country_visited, :country_to_visit,                                   
                                  :password, :password_confirmation, :about_me, :avatar)
                                #  :password_hash, :remember_hash)                                
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
