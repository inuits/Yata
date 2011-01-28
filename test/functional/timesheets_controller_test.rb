require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:timesheets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_timesheet
    assert_difference('Timesheet.count') do
      post :create, :timesheet => { }
    end

    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  def test_should_show_timesheet
    get :show, :id => timesheets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => timesheets(:one).id
    assert_response :success
  end

  def test_should_update_timesheet
    put :update, :id => timesheets(:one).id, :timesheet => { }
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  def test_should_destroy_timesheet
    assert_difference('Timesheet.count', -1) do
      delete :destroy, :id => timesheets(:one).id
    end

    assert_redirected_to timesheets_path
  end
end
