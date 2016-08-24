require 'test_helper'

class NowhereControllerTest < ActionController::TestCase

  def test_create_redirects_to_identifies
    post :create
    assert_redirected_to %r(\Ahttp://localhost:3000/identify/new)
  end

  def test_create_redirects_with_encoded_saml_request
    post :create
    many_letters_numbers_or_percentage = '[\w\%]{50,}'
    assert_redirected_to /\?SAMLRequest\=#{many_letters_numbers_or_percentage}\z/
  end

end
