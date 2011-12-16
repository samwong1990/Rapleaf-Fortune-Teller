require 'test_helper'

class FortuneTellersControllerTest < ActionController::TestCase
  setup do
    @fortune_teller = fortune_tellers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fortune_tellers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fortune_teller" do
    assert_difference('FortuneTeller.count') do
      post :create, fortune_teller: @fortune_teller.attributes
    end

    assert_redirected_to fortune_teller_path(assigns(:fortune_teller))
  end

  test "should show fortune_teller" do
    get :show, id: @fortune_teller.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fortune_teller.to_param
    assert_response :success
  end

  test "should update fortune_teller" do
    put :update, id: @fortune_teller.to_param, fortune_teller: @fortune_teller.attributes
    assert_redirected_to fortune_teller_path(assigns(:fortune_teller))
  end

  test "should destroy fortune_teller" do
    assert_difference('FortuneTeller.count', -1) do
      delete :destroy, id: @fortune_teller.to_param
    end

    assert_redirected_to fortune_tellers_path
  end
end
