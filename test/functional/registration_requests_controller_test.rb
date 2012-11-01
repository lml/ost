# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class RegistrationRequestsControllerTest < ActionController::TestCase
  setup do
    @registration_request = registration_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_request" do
    assert_difference('RegistrationRequest.count') do
      post :create, registration_request: { is_auditing: @registration_request.is_auditing, section_id: @registration_request.section_id, user_id: @registration_request.user_id }
    end

    assert_redirected_to registration_request_path(assigns(:registration_request))
  end

  test "should show registration_request" do
    get :show, id: @registration_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration_request
    assert_response :success
  end

  test "should update registration_request" do
    put :update, id: @registration_request, registration_request: { is_auditing: @registration_request.is_auditing, section_id: @registration_request.section_id, user_id: @registration_request.user_id }
    assert_redirected_to registration_request_path(assigns(:registration_request))
  end

  test "should destroy registration_request" do
    assert_difference('RegistrationRequest.count', -1) do
      delete :destroy, id: @registration_request
    end

    assert_redirected_to registration_requests_path
  end
end
