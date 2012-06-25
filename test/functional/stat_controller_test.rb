require 'test_helper'

class StatControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get user" do
    get :user
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
