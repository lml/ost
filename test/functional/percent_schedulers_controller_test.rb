require 'test_helper'

class PercentSchedulersControllerTest < ActionController::TestCase
  setup do
    @percent_scheduler = percent_schedulers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:percent_schedulers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create percent_scheduler" do
    assert_difference('PercentScheduler.count') do
      post :create, percent_scheduler: { learning_condition_id: @percent_scheduler.learning_condition_id, settings: @percent_scheduler.settings }
    end

    assert_redirected_to percent_scheduler_path(assigns(:percent_scheduler))
  end

  test "should show percent_scheduler" do
    get :show, id: @percent_scheduler
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @percent_scheduler
    assert_response :success
  end

  test "should update percent_scheduler" do
    put :update, id: @percent_scheduler, percent_scheduler: { learning_condition_id: @percent_scheduler.learning_condition_id, settings: @percent_scheduler.settings }
    assert_redirected_to percent_scheduler_path(assigns(:percent_scheduler))
  end

  test "should destroy percent_scheduler" do
    assert_difference('PercentScheduler.count', -1) do
      delete :destroy, id: @percent_scheduler
    end

    assert_redirected_to percent_schedulers_path
  end
end
