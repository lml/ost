# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class AssignmentCoworkersControllerTest < ActionController::TestCase
  setup do
    @assignment_coworker = assignment_coworkers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_coworkers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_coworker" do
    assert_difference('AssignmentCoworker.count') do
      post :create, assignment_coworker: { student_assignment_id: @assignment_coworker.student_assignment_id, student_id: @assignment_coworker.student_id }
    end

    assert_redirected_to assignment_coworker_path(assigns(:assignment_coworker))
  end

  test "should show assignment_coworker" do
    get :show, id: @assignment_coworker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_coworker
    assert_response :success
  end

  test "should update assignment_coworker" do
    put :update, id: @assignment_coworker, assignment_coworker: { student_assignment_id: @assignment_coworker.student_assignment_id, student_id: @assignment_coworker.student_id }
    assert_redirected_to assignment_coworker_path(assigns(:assignment_coworker))
  end

  test "should destroy assignment_coworker" do
    assert_difference('AssignmentCoworker.count', -1) do
      delete :destroy, id: @assignment_coworker
    end

    assert_redirected_to assignment_coworkers_path
  end
end
