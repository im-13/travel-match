require 'test_helper'

class CarrierwaveImagesControllerTest < ActionController::TestCase
  setup do
    @carrierwave_image = carrierwave_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carrierwave_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carrierwave_image" do
    assert_difference('CarrierwaveImage.count') do
      post :create, carrierwave_image: {  }
    end

    assert_redirected_to carrierwave_image_path(assigns(:carrierwave_image))
  end

  test "should show carrierwave_image" do
    get :show, id: @carrierwave_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carrierwave_image
    assert_response :success
  end

  test "should update carrierwave_image" do
    patch :update, id: @carrierwave_image, carrierwave_image: {  }
    assert_redirected_to carrierwave_image_path(assigns(:carrierwave_image))
  end

  test "should destroy carrierwave_image" do
    assert_difference('CarrierwaveImage.count', -1) do
      delete :destroy, id: @carrierwave_image
    end

    assert_redirected_to carrierwave_images_path
  end
end
