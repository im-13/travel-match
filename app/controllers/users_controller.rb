class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy, :show_messages, :show_my_blog, :show_my_trips]
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
    
    @rel_user_followed_by_current_user = current_user.query_as(:cur_user).match('cur_user-[rel:following]->select_user').where(" select_user.uuid = '#{@user.uuid}'").pluck(:rel).first
    @favorite = @user.query_as(:user).match("(user:User)-[rel:following]->(m:User)").where("user.uuid = '#{@user.uuid}'").order('rel.created_at DESC').return(:m).proxy_as(User, :m)
    @fav_count = @favorite.length

    @visitors = @user.query_as(:user).match("(user:User)-[rel:People_You_Were_Viewed_By]->(m:User)").where("user.uuid = '#{@user.uuid}'").order('rel.time_viewed DESC').return(:m).proxy_as(User, :m)
    @vis_count = @visitors.length
    #if not the session user
    if !current_user?(@user)
      #establish a connection with the session user
      establish_user_connection(@user) #people you've viewed, and someone sees that you viewed them
    end

    @user_blog = Blog.query_as(:n).match("n").where("n.user_uuid = '#{@user.uuid}'").proxy_as(Blog, :n).paginate(:page => params[:page], :per_page => 5, :order => { created_at: :desc }, return: :'distinct n')
    @user_country_of_residence = @user.lives_in
    @wantsToGoTo = @user.wants_to_go_to
    @hasBeenTo = @user.has_been_to

    @trips = @user.plan
    @trips_count = @trips.length
    #Trip.all.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc })
    @user_matches = default_match
  end

  def show_my_blog
    @user = current_user
    @blog = Blog.new
    @blog.user_name = @user.full_name
    @blog.user_uuid = @user.uuid
    @blog.user_gravatar_url = @user.gravatar_url 
    @blog.user_email = @user.email 
    @user_blog = Blog.query_as(:n).match("n").where("n.user_uuid = '#{@user.uuid}'").proxy_as(Blog, :n).paginate(:page => params[:page], :per_page => 5, :order => { created_at: :desc }, return: :'distinct n')
  end

  def show_my_trips
    @user = current_user
    @trip = Trip.new
    @trip.user_uuid = @user.uuid 
    @user_trips = Trip.query_as(:n).match("n").where("n.user_uuid = '#{@user.uuid}'").proxy_as(Trip, :n).paginate(:page => params[:page], :per_page => 5, :order => { created_at: :desc }, return: :'distinct n')
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user_traveled_list = @user.has_been_to
    @user_to_travel_to = @user.wants_to_go_to
    # get user's country_of_residence, 2 arrays of user's countries, 
    # array of hobbies
  end

  # POST /users
  # POST /users.jsonp
  def create

    if bday_not_valid
      puts "BDAY NOT VALID"
      respond_to do |format|
        flash[:danger] = "Date of birth is invalid. Please re-submit the form."
        format.html { redirect_to signup_path }
      end
      return
    end

    @user = User.new(user_params)

    if email_not_unique(@user.email)
      puts "EMAIL NOT UNIQUE"
      respond_to do |format|
        flash[:danger] = "Email address belongs to an existing account. Please log in as #{@user.email} or re-submit the Sign up form with a different email address."
        format.html { render 'new' }
      end
      return
    end

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
        if params[:user][:country_of_residence_code]
          country_reside = @user.country_of_residence
          resideArr = country_reside.split(",")
          make_decision(@user, resideArr, 1)
        end
        if params[:user][:country_visited]
          #we need to accumulate the country_visited somehow
          visited = params[:user][:country_visited] 
          visitedArr = visited.split(",")
          visitedArr = country_code_convert(visitedArr)
          visitedArr = visitedArr.uniq
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
          tovisitArr = tovisitArr.uniq
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
        flash[:danger] = "Profile was not updated."
        @user_traveled_list = @user.has_been_to
        @user_to_travel_to = @user.wants_to_go_to
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def traveled
    if params[:country_visited]
      @user = User.find(params[:id])
      visited = params[:country_visited] 
      visitedArr = visited.split(",")
      visitedArr = country_code_convert(visitedArr)
      visitedArr = visitedArr.uniq
      if country_check(visitedArr)
        make_decision(@user, visitedArr, 2)
      end
      render json: { status: :ok }
    else
      render json: { status: :failed }
    end
    
  end

  def want
    if params[:country_to_visit]
      @user = User.find(params[:id])
      toVisit = params[:country_to_visit] 
      toVisitArr = toVisit.split(",")
      toVisitArr = country_code_convert(toVisitArr)
      toVisitArr = toVisitArr.uniq
      if country_check(toVisitArr)
        make_decision(@user, toVisitArr, 3)
      end
      render json: { status: :ok }
    else
      render json: { status: :failed }
    end

  end

  def show_messages
    @session_user = current_user
    @conversations = @session_user.channel_to.order(last_viewed: :desc)
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
                                  :country_of_residence_code,                                  
                                  :password, :password_confirmation, :about_me, :avatar)
                                                              
    end

    # Before filters

    def email_not_unique(email_address)
      db_user = User.find_by(email: "#{email_address}")
      if db_user
        return true
      else
        return false
      end
    end

    def bday_not_valid
      year = user_params['date_of_birth(1i)'].to_i
      month = user_params['date_of_birth(2i)'].to_i
      day = user_params['date_of_birth(3i)'].to_i
      if Date.valid_date?(year, month, day)
        return false
      else
        return true
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
