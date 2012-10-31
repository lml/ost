# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class ConsentOptionsControllerTest < ActionController::TestCase
  setup do
    @consent_option = consent_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consent_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consent_option" do
    assert_difference('ConsentOptions.count') do
      post :create, consent_option: { closes_at: @consent_option.closes_at, consent_form_id: @consent_option.consent_form_id, consent_optionable_id: @consent_option.consent_optionable_id, consent_optionable_type: @consent_option.consent_optionable_type, opens_at: @consent_option.opens_at }
    end

    assert_redirected_to consent_option_path(assigns(:consent_option))
  end

  test "should show consent_option" do
    get :show, id: @consent_option
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consent_option
    assert_response :success
  end

  test "should update consent_option" do
    put :update, id: @consent_option, consent_option: { closes_at: @consent_option.closes_at, consent_form_id: @consent_option.consent_form_id, consent_optionable_id: @consent_option.consent_optionable_id, consent_optionable_type: @consent_option.consent_optionable_type, opens_at: @consent_option.opens_at }
    assert_redirected_to consent_option_path(assigns(:consent_option))
  end

  test "should destroy consent_option" do
    assert_difference('ConsentOptions.count', -1) do
      delete :destroy, id: @consent_option
    end

    assert_redirected_to consent_options_index_path
  end
end
