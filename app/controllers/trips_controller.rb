class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)
    @trip.user_name = current_user.full_name
    @trip.user_uuid = current_user.uuid
    @trip.user_gravatar_url = current_user.gravatar_url 
    @trip.user_email = current_user.email 
    @CarrierwaveImage = CarrierwaveImage.create
    respond_to do |format|
      if @trip.save

        country = create_if_not_found @trip.country
        #we have the country
        rel1 = IsLocatedIn.new(from_node: @trip, to_node: country) 
        rel1.save
        rel2 = Plan.new(from_node: current_user, to_node: @trip)
        rel2.save
        rel3 = TripHasAttached.new(from_node: @trip, to_node: @CarrierwaveImage)
        rel3.save

        flash[:success] = "Trip was successfully created."
        format.html { redirect_to @trip }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        flash[:success] = "Trip was successfully updated."
        format.html { redirect_to @trip }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      flash[:success] = "Trip was successfully destroyed."
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:place, :country_code, :description, :date_from, :date_to, :photo)
    end
end
