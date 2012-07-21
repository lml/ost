require 'test_helper'

class AssignmentExercisesControllerTest < ActionController::TestCase
  setup do
    @assignment_exercise = assignment_exercises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_exercises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_exercise" do
    assert_difference('AssignmentExercise.count') do
      post :create, assignment_exercise: { assignment_id: @assignment_exercise.assignment_id, number: @assignment_exercise.number, topic_exercise_id: @assignment_exercise.topic_exercise_id }
    end

    assert_redirected_to assignment_exercise_path(assigns(:assignment_exercise))
  end

  test "should show assignment_exercise" do
    get :show, id: @assignment_exercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_exercise
    assert_response :success
  end

  test "should update assignment_exercise" do
    put :update, id: @assignment_exercise, assignment_exercise: { assignment_id: @assignment_exercise.assignment_id, number: @assignment_exercise.number, topic_exercise_id: @assignment_exercise.topic_exercise_id }
    assert_redirected_to assignment_exercise_path(assigns(:assignment_exercise))
  end

  test "should destroy assignment_exercise" do
    assert_difference('AssignmentExercise.count', -1) do
      delete :destroy, id: @assignment_exercise
    end

    assert_redirected_to assignment_exercises_path
  end
end
