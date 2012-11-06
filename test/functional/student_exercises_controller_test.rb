# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class StudentExercisesControllerTest < ActionController::TestCase
  setup do
    @student_exercise = student_exercises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_exercises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_exercise" do
    assert_difference('StudentExercise.count') do
      post :create, student_exercise: { assignment_exercise_id: @student_exercise.assignment_exercise_id, automated_credit: @student_exercise.automated_credit, content_cache: @student_exercise.content_cache, free_response: @student_exercise.free_response, free_response_confidence: @student_exercise.free_response_confidence, free_response_submitted_at: @student_exercise.free_response_submitted_at, manual_credit: @student_exercise.manual_credit, selected_answer: @student_exercise.selected_answer, selected_answer_submitted_at: @student_exercise.selected_answer_submitted_at, student_assignment_id: @student_exercise.student_assignment_id, was_submitted_late: @student_exercise.was_submitted_late }
    end

    assert_redirected_to student_exercise_path(assigns(:student_exercise))
  end

  test "should show student_exercise" do
    get :show, id: @student_exercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_exercise
    assert_response :success
  end

  test "should update student_exercise" do
    put :update, id: @student_exercise, student_exercise: { assignment_exercise_id: @student_exercise.assignment_exercise_id, automated_credit: @student_exercise.automated_credit, content_cache: @student_exercise.content_cache, free_response: @student_exercise.free_response, free_response_confidence: @student_exercise.free_response_confidence, free_response_submitted_at: @student_exercise.free_response_submitted_at, manual_credit: @student_exercise.manual_credit, selected_answer: @student_exercise.selected_answer, selected_answer_submitted_at: @student_exercise.selected_answer_submitted_at, student_assignment_id: @student_exercise.student_assignment_id, was_submitted_late: @student_exercise.was_submitted_late }
    assert_redirected_to student_exercise_path(assigns(:student_exercise))
  end

  test "should destroy student_exercise" do
    assert_difference('StudentExercise.count', -1) do
      delete :destroy, id: @student_exercise
    end

    assert_redirected_to student_exercises_path
  end
end
