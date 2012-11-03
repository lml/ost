# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class TopicExercisesControllerTest < ActionController::TestCase
  setup do
    @topic_exercise = topic_exercises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topic_exercises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic_exercise" do
    assert_difference('TopicExercise.count') do
      post :create, topic_exercise: { concept_id: @topic_exercise.concept_id, exercise_id: @topic_exercise.exercise_id, number: @topic_exercise.number, topic_id: @topic_exercise.topic_id }
    end

    assert_redirected_to topic_exercise_path(assigns(:topic_exercise))
  end

  test "should show topic_exercise" do
    get :show, id: @topic_exercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic_exercise
    assert_response :success
  end

  test "should update topic_exercise" do
    put :update, id: @topic_exercise, topic_exercise: { concept_id: @topic_exercise.concept_id, exercise_id: @topic_exercise.exercise_id, number: @topic_exercise.number, topic_id: @topic_exercise.topic_id }
    assert_redirected_to topic_exercise_path(assigns(:topic_exercise))
  end

  test "should destroy topic_exercise" do
    assert_difference('TopicExercise.count', -1) do
      delete :destroy, id: @topic_exercise
    end

    assert_redirected_to topic_exercises_path
  end
end
