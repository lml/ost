require 'test_helper'

class EducatorsControllerTest < ActionController::TestCase
  setup do
    @educator = educators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:educators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create educator" do
    assert_difference('Educator.count') do
      post :create, educator: { is_grader: @educator.is_grader, is_instructor: @educator.is_instructor, is_teaching_assistant: @educator.is_teaching_assistant, klass_id: @educator.klass_id, user_id: @educator.user_id }
    end

    assert_redirected_to educator_path(assigns(:educator))
  end

  test "should show educator" do
    get :show, id: @educator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @educator
    assert_response :success
  end

  test "should update educator" do
    put :update, id: @educator, educator: { is_grader: @educator.is_grader, is_instructor: @educator.is_instructor, is_teaching_assistant: @educator.is_teaching_assistant, klass_id: @educator.klass_id, user_id: @educator.user_id }
    assert_redirected_to educator_path(assigns(:educator))
  end

  test "should destroy educator" do
    assert_difference('Educator.count', -1) do
      delete :destroy, id: @educator
    end

    assert_redirected_to educators_path
  end
end
