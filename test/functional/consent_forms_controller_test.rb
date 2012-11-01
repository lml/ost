# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class ConsentFormsControllerTest < ActionController::TestCase
  setup do
    @consent_form = consent_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consent_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consent_form" do
    assert_difference('ConsentForm.count') do
      post :create, consent_form: { esignature_required: @consent_form.esignature_required, html: @consent_form.html, name: @consent_form.name }
    end

    assert_redirected_to consent_form_path(assigns(:consent_form))
  end

  test "should show consent_form" do
    get :show, id: @consent_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consent_form
    assert_response :success
  end

  test "should update consent_form" do
    put :update, id: @consent_form, consent_form: { esignature_required: @consent_form.esignature_required, html: @consent_form.html, name: @consent_form.name }
    assert_redirected_to consent_form_path(assigns(:consent_form))
  end

  test "should destroy consent_form" do
    assert_difference('ConsentForm.count', -1) do
      delete :destroy, id: @consent_form
    end

    assert_redirected_to consent_forms_path
  end
end
