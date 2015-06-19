require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "TravelMatch App"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | TravelMatch App"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | TravelMatch App"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | TravelMatch App"
  end
  
end