require 'test_helper'

class LogicsControllerTest < ActionController::TestCase
  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get result" do
    get :result
    assert_response :success
  end

end
