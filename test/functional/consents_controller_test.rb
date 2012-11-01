# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class ConsentsControllerTest < ActionController::TestCase
  setup do
    @consent = consents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:consents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create consent" do
    assert_difference('Consent.count') do
      post :create, consent: { consent_form_id: @consent.consent_form_id, consentable_id: @consent.consentable_id, consentable_type: @consent.consentable_type, did_consent: @consent.did_consent, esignature: @consent.esignature }
    end

    assert_redirected_to consent_path(assigns(:consent))
  end

  test "should show consent" do
    get :show, id: @consent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @consent
    assert_response :success
  end

  test "should update consent" do
    put :update, id: @consent, consent: { consent_form_id: @consent.consent_form_id, consentable_id: @consent.consentable_id, consentable_type: @consent.consentable_type, did_consent: @consent.did_consent, esignature: @consent.esignature }
    assert_redirected_to consent_path(assigns(:consent))
  end

  test "should destroy consent" do
    assert_difference('Consent.count', -1) do
      delete :destroy, id: @consent
    end

    assert_redirected_to consents_path
  end
end
