# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class OrganizationManagersControllerTest < ActionController::TestCase
  setup do
    @organization_manager = organization_managers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_managers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_manager" do
    assert_difference('OrganizationManager.count') do
      post :create, organization_manager: { organization_id: @organization_manager.organization_id, user_id: @organization_manager.user_id }
    end

    assert_redirected_to organization_manager_path(assigns(:organization_manager))
  end

  test "should show organization_manager" do
    get :show, id: @organization_manager
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_manager
    assert_response :success
  end

  test "should update organization_manager" do
    put :update, id: @organization_manager, organization_manager: { organization_id: @organization_manager.organization_id, user_id: @organization_manager.user_id }
    assert_redirected_to organization_manager_path(assigns(:organization_manager))
  end

  test "should destroy organization_manager" do
    assert_difference('OrganizationManager.count', -1) do
      delete :destroy, id: @organization_manager
    end

    assert_redirected_to organization_managers_path
  end
end
