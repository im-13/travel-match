class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
#    @user = User.find(params[:id])
    @user = User.first # first just for now ;)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.jsonp
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save

        #residency
        country = @user.country_of_residency
        #country = country.lowercase
        countryFound = Country.find_by( name: "#{country}" )
        if countryFound
          countryFound.lives_in << @user
        else
          countrycreated = Country.new
          countrycreated.name = country
          countrycreated.save
          countrycreated.lives_in << @user
          #@user.create_rel("lives_in", countrycreated)
          #@user.save
          #( params[:country_of_residency] )
        end

        #country visited
        visited = @user.country_visited
        visitedArr = visited.split(",")
        visitedArr.each do |countryvisited| #need to check loop
          format.html { redirect_to @user, notice: "country visited #{countryvisited}" }
          countryhasvisited = Country.find_by( name: "#{countryvisited}")
          if countryhasvisited
            countryhasvisited.has_visited << @user
          else
            countrycreated = Country.new
            countrycreated.name = countryvisited
            countrycreated.save
            countrycreated.has_visited << @user
          end
        end
        @user.country_visited = visitedArr
        

        tovisit = @user.country_to_visit
        tovisitArr = tovisit.split(",")
        tovisitArr.each do |countrytovisit|
          format.html { redirect_to @user, notice: "country to visit #{countryvisited}" }
          countrytogoto = Country.find_by( name: "#{countrytovisit}")
          if countrytogoto
            countrytogoto.want_to_visit << @user
          else
            countrycreated = Country.new
            countrycreated.name = countrytovisit
            countrycreated.save
            countrycreated.want_to_visit << @user
          end
        end
        @user.country_to_visit = tovisitArr
        @user.save


        flash[:success] = "Welcome to Travel Match!"
        format.html { redirect_to @user } #, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
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
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
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
                                  :country_of_residency, :country_visited, :country_to_visit,                                   
                                   :password_hash, :password, :password_confirmation)                                
    end
end
