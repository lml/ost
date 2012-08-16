require 'test_helper'

class FeedbackConditionsControllerTest < ActionController::TestCase
  setup do
    @feedback_condition = feedback_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_condition" do
    assert_difference('FeedbackCondition.count') do
      post :create, feedback_condition: { learning_condition_id: @feedback_condition.learning_condition_id, number: @feedback_condition.number, settings: @feedback_condition.settings, type: @feedback_condition.type }
    end

    assert_redirected_to feedback_condition_path(assigns(:feedback_condition))
  end

  test "should show feedback_condition" do
    get :show, id: @feedback_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback_condition
    assert_response :success
  end

  test "should update feedback_condition" do
    put :update, id: @feedback_condition, feedback_condition: { learning_condition_id: @feedback_condition.learning_condition_id, number: @feedback_condition.number, settings: @feedback_condition.settings, type: @feedback_condition.type }
    assert_redirected_to feedback_condition_path(assigns(:feedback_condition))
  end

  test "should destroy feedback_condition" do
    assert_difference('FeedbackCondition.count', -1) do
      delete :destroy, id: @feedback_condition
    end

    assert_redirected_to feedback_conditions_path
  end
end
