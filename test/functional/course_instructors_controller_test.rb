require 'test_helper'

class CourseInstructorsControllerTest < ActionController::TestCase
  setup do
    @course_instructor = course_instructors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_instructors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_instructor" do
    assert_difference('CourseInstructor.count') do
      post :create, course_instructor: { course_id: @course_instructor.course_id, user_id: @course_instructor.user_id }
    end

    assert_redirected_to course_instructor_path(assigns(:course_instructor))
  end

  test "should show course_instructor" do
    get :show, id: @course_instructor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course_instructor
    assert_response :success
  end

  test "should update course_instructor" do
    put :update, id: @course_instructor, course_instructor: { course_id: @course_instructor.course_id, user_id: @course_instructor.user_id }
    assert_redirected_to course_instructor_path(assigns(:course_instructor))
  end

  test "should destroy course_instructor" do
    assert_difference('CourseInstructor.count', -1) do
      delete :destroy, id: @course_instructor
    end

    assert_redirected_to course_instructors_path
  end
end
