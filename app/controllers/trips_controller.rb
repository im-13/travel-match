require 'date'
class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :create, :update, :destroy, :find]

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all.paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc })
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
    user = current_user

    if is_invalid_date
      respond_to do |format|
        flash[:danger] = "You have selected invalid dates"
        format.html { redirect_to newtrip_path }
      end
    else
      @trip = Trip.new(trip_params)
      @trip.user_uuid = user.uuid
      respond_to do |format|
        if @trip.save

          country = create_if_not_found @trip.country
          rel1 = IsLocatedIn.new(from_node: @trip, to_node: country) 
          rel1.save
          rel2 = Plan.new(from_node: user, to_node: @trip)
          rel2.save
          rel3 = WantsToGoTo.new(from_node: user, to_node: country)
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

  def find
    match_exp = ""
    where_exp = ""

    if params[:check_box_country] == "1"
      target_country_code = trip_params[:country_code]
      match_exp << "t-[:is_located_in]->(country:Country)"
      where_exp << "country.code = '#{target_country_code}'"  
    end

    if params[:check_box_place] == "1"
      target_place = trip_params[:place].titleize
      if where_exp != ""
        where_exp << " AND "  
      end
      where_exp << "t.place = '#{target_place}'"
    end

    if params[:check_box_date_from] == "1" && params[:check_box_date_to] == nil
      year = trip_params['date_from(1i)'].to_i
      month = trip_params['date_from(2i)'].to_i
      day = trip_params['date_from(3i)'].to_i - 1 #Correction due to Unix time issues
      target_date_from = Date.new(year, month, day).to_time.to_i
      if where_exp != ""
        where_exp << " AND "  
      end
      where_exp << "t.date_to >= " << target_date_from.to_s
    end

    if params[:check_box_date_to] == "1" && params[:check_box_date_from] == nil
      year = trip_params['date_to(1i)'].to_i
      month = trip_params['date_to(2i)'].to_i
      day = trip_params['date_to(3i)'].to_i
      target_date_to = Date.new(year, month, day).to_time.to_i
      if where_exp != ""
        where_exp << " AND "  
      end
      where_exp << "t.date_from <= " << target_date_to.to_s
    end

    if params[:check_box_date_from] == "1" && params[:check_box_date_to] == "1"
      year_from = trip_params['date_from(1i)'].to_i
      month_from = trip_params['date_from(2i)'].to_i
      day_from = trip_params['date_from(3i)'].to_i  - 1 #Correction due to Unix time issues
      target_date_from = Date.new(year_from, month_from, day_from).to_time.to_i.to_s
      year_to = trip_params['date_to(1i)'].to_i
      month_to = trip_params['date_to(2i)'].to_i
      day_to = trip_params['date_to(3i)'].to_i
      target_date_to = Date.new(year_to, month_to, day_to).to_time.to_i.to_s
      if where_exp != ""
        where_exp << " AND "  
      end
      where_exp << "( t.date_to >= " << target_date_to << " AND t.date_from >= " << target_date_from << " AND t.date_from <= " << target_date_to << " OR t.date_to >= " << target_date_to << " AND t.date_from <= " << target_date_from << " OR t.date_to <= " << target_date_to << " AND t.date_from >= " << target_date_from << " OR t.date_to >= " << target_date_from << " AND t.date_to <= " << target_date_to << " AND t.date_from <= " << target_date_from << " ) "
    end

    #if match_exp == "" && where_exp == ""
    #  @found_trips = nil
    #else
      @found_trips = Trip.query_as(:t).match("#{match_exp}").where("#{where_exp}").proxy_as(Trip, :t).paginate(:page => params[:page], :per_page => 5, :order => { updated_at: :desc }, return: :'distinct t')
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def is_invalid_date
      year_from = trip_params['date_from(1i)'].to_i
      month_from = trip_params['date_from(2i)'].to_i
      day_from = trip_params['date_from(3i)'].to_i
      
      year_to = trip_params['date_to(1i)'].to_i
      month_to = trip_params['date_to(2i)'].to_i
      day_to = trip_params['date_to(3i)'].to_i

      if !(check_date(year_from, month_from, day_from ) and (check_date(year_to, month_to, day_to)))
        return true 
      else
        first_date = date_to_integer( year_from, month_from, day_from )
        second_date = date_to_integer( year_to, month_to, day_to )
        if !chronological_order(first_date, second_date)#if not chronological order
          return true
        else
          return false
        end
        return false
      end
      #Date.valid_date?(2001,2,3)        #=> true
      #Date.valid_date?(2001,2,29)       #=> false
    end

    def check_date(year, month, day )
      Date.valid_date?(year,month,day)
    end

    def chronological_order( first_date, second_date )
      diff = second_date-first_date
      if diff < 0
        return false
      else
        return true
      end
    end

    def date_to_integer(year, month, day)
      Date.new(year,month,day).to_time.to_i
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:place, :country_code, :description, :date_from, :date_to, :photo,
                                   :check_box_country, :check_box_place, :check_box_date_from,
                                   :check_box_date_to)
    end
end
