require 'test_helper'

class IdentifiesControllerTest < ActionController::TestCase

  def test_new_redirects_to_sign_in
    get :new
    assert_redirected_to new_user_session_path
  end

end
