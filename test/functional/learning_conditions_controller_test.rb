require 'test_helper'

class LearningConditionsControllerTest < ActionController::TestCase
  setup do
    @learning_condition = learning_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:learning_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create learning_condition" do
    assert_difference('LearningCondition.count') do
      post :create, learning_condition: { cohort_id: @learning_condition.cohort_id }
    end

    assert_redirected_to learning_condition_path(assigns(:learning_condition))
  end

  test "should show learning_condition" do
    get :show, id: @learning_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @learning_condition
    assert_response :success
  end

  test "should update learning_condition" do
    put :update, id: @learning_condition, learning_condition: { cohort_id: @learning_condition.cohort_id }
    assert_redirected_to learning_condition_path(assigns(:learning_condition))
  end

  test "should destroy learning_condition" do
    assert_difference('LearningCondition.count', -1) do
      delete :destroy, id: @learning_condition
    end

    assert_redirected_to learning_conditions_path
  end
end
