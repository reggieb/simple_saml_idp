require 'test_helper'

class ManageUsersControllerTest < ActionController::TestCase

  def setup
    sign_in user
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_user_is_listed_in_index
    get :index
    assert_select 'td', user.email
  end

end
