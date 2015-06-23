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

        flash[:success] = "Welcome to Travel Match!!"
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

      params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth,
                                   :gender, :password_hash, :password_salt,
                                   :password, :password_confirmation, 
                                   :country_of_residency)
    end
end
