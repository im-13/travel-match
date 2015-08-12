class CarrierwaveImagesController < ApplicationController
  before_action :set_carrierwave_image, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /carrierwave_images
  # GET /carrierwave_images.json
  def index
    @carrierwave_images = CarrierwaveImage.all
  end

  # GET /carrierwave_images/1
  # GET /carrierwave_images/1.json
  def show
  end

  # GET /carrierwave_images/new
  def new
    @carrierwave_image = CarrierwaveImage.new
  end

  # GET /carrierwave_images/1/edit
  def edit
  end

  # POST /carrierwave_images
  # POST /carrierwave_images.json
  def create
    bid = params[:asset][:bid]
    value = params[:asset][:asset]
    @blog = Blog.find_by(uuid: bid)
    @carrierwave_image = CarrierwaveImage.new(carrierwave_image_params)
    @blog.count_photos += 1
    @carrierwave_image.asset = value
    @carrierwave_image.user_name = current_user.full_name
    @carrierwave_image.user_uuid = current_user.uuid
    @carrierwave_image.user_gravatar_url = current_user.gravatar_url
    @carrierwave_image.user_avatar_url = current_user.avatar_url 
    @carrierwave_image.blog_id = bid
    @carrierwave_image.save
    @blog.save

    respond_to do |format|
      if @carrierwave_image.save
        imagelink = HasAttached.new(from_node: @blog, to_node: @carrierwave_image)
        imagelink.save
        format.html { redirect_to  @blog, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @carrierwave_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carrierwave_images/1
  # PATCH/PUT /carrierwave_images/1.json
  def update
    respond_to do |format|
      if @carrierwave_image.update(carrierwave_image_params)
        format.html { redirect_to @carrierwave_image, notice: 'Carrierwave image was successfully updated.' }
        format.json { render :show, status: :ok, location: @carrierwave_image }
      else
        format.html { render :edit }
        format.json { render json: @carrierwave_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carrierwave_images/1
  # DELETE /carrierwave_images/1.json
  def destroy
    @carrierwave_image = CarrierwaveImage.find(params[:id])
    @blog = Blog.find_by(id: @comment.blog_id)
    @carrierwave_image.destroy
    respond_to do |format|
      format.html { redirect_to @blog, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrierwave_image
      @carrierwave_image = CarrierwaveImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carrierwave_image_params
      params.require(:carrierwave_image).permit(:asset, :remove_asset, :user_name, :user_uuid,)
    end
end
