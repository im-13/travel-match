require 'neo4j-will_paginate_redux'

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.as(:p).all.paginate(:page => params[:page], :per_page => 10, return: :p, order: :first_name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    # get user's country_of_residence, 2 arrays of user's countries, 
    # array of hobbies
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
        country = create_if_not_found params[:user][:country_of_residency]
        #we have the country
        rel = LivesIn.new(from_node: @user, to_node: country)
        #country.lives_in << @user 
        rel.save

        log_in @user
        remember @user
        flash[:success] = "Welcome to Travel Match!"
        format.html { redirect_to @user } 
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
      @user = User.find(params[:id])
      if @user.update(user_params)

        #country visited
        if visited = params[:user][:country_visited]
          visitedArr = visited.split(",")
          visitedArr.each do |countryvisited| #need to check loop
            countryhasvisited = create_if_not_found "#{countryvisited}"
            rel =  HasBeenTo.new(from_node: @user, to_node: countryhasvisited)
            rel.save
            #countryhasvisited.has_visited << @user
          end
          @user.country_visited = visitedArr
        end

        #country to visit
        if tovisit = params[:user][:country_to_visit]
          tovisitArr = tovisit.split(",")
          tovisitArr.each do |countrytovisit|
            countrytogoto = create_if_not_found "#{countrytovisit}"
            rel = WantsToGoTo.new(from_node: @user, to_node: countrytogoto )
            rel.save
            #countrytogoto.want_to_visit << @user
          end
          @user.country_to_visit = tovisitArr
        end
        #@user.save #not neccessary

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
                                  :password_hash, :password, :password_confirmation,
                                  :remember_hash)                                
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
    
end
