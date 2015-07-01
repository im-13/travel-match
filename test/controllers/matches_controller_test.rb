require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  test "should get default" do
    get :default
    assert_response :success
  end

  test "should get specific_match" do
    get :specific_match
    assert_response :success
  end

end
