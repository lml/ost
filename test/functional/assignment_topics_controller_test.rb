require 'test_helper'

class AssignmentTopicsControllerTest < ActionController::TestCase
  setup do
    @assignment_topic = assignment_topics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_topics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_topic" do
    assert_difference('AssignmentTopic.count') do
      post :create, assignment_topic: { assignment_id: @assignment_topic.assignment_id, topic_id: @assignment_topic.topic_id }
    end

    assert_redirected_to assignment_topic_path(assigns(:assignment_topic))
  end

  test "should show assignment_topic" do
    get :show, id: @assignment_topic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_topic
    assert_response :success
  end

  test "should update assignment_topic" do
    put :update, id: @assignment_topic, assignment_topic: { assignment_id: @assignment_topic.assignment_id, topic_id: @assignment_topic.topic_id }
    assert_redirected_to assignment_topic_path(assigns(:assignment_topic))
  end

  test "should destroy assignment_topic" do
    assert_difference('AssignmentTopic.count', -1) do
      delete :destroy, id: @assignment_topic
    end

    assert_redirected_to assignment_topics_path
  end
end
