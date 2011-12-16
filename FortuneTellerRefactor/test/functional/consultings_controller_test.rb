require 'test_helper'

class ConsultingsControllerTest < ActionController::TestCase
  setup do
    @consulting = consultings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consultings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consulting" do
    assert_difference('Consulting.count') do
      post :create, consulting: @consulting.attributes
    end

    assert_redirected_to consulting_path(assigns(:consulting))
  end

  test "should show consulting" do
    get :show, id: @consulting.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consulting.to_param
    assert_response :success
  end

  test "should update consulting" do
    put :update, id: @consulting.to_param, consulting: @consulting.attributes
    assert_redirected_to consulting_path(assigns(:consulting))
  end

  test "should destroy consulting" do
    assert_difference('Consulting.count', -1) do
      delete :destroy, id: @consulting.to_param
    end

    assert_redirected_to consultings_path
  end
end
