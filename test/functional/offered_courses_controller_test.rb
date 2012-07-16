require 'test_helper'

class OfferedCoursesControllerTest < ActionController::TestCase
  setup do
    @offered_course = offered_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offered_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offered_course" do
    assert_difference('OfferedCourse.count') do
      post :create, offered_course: { approved_emails: @offered_course.approved_emails, consent_form_id: @offered_course.consent_form_id, course_id: @offered_course.course_id, start_date: @offered_course.start_date }
    end

    assert_redirected_to offered_course_path(assigns(:offered_course))
  end

  test "should show offered_course" do
    get :show, id: @offered_course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offered_course
    assert_response :success
  end

  test "should update offered_course" do
    put :update, id: @offered_course, offered_course: { approved_emails: @offered_course.approved_emails, consent_form_id: @offered_course.consent_form_id, course_id: @offered_course.course_id, start_date: @offered_course.start_date }
    assert_redirected_to offered_course_path(assigns(:offered_course))
  end

  test "should destroy offered_course" do
    assert_difference('OfferedCourse.count', -1) do
      delete :destroy, id: @offered_course
    end

    assert_redirected_to offered_courses_path
  end
end
