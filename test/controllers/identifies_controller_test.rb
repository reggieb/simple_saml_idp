require 'test_helper'

class IdentifiesControllerTest < ActionController::TestCase

  def test_new_redirects_to_sign_in
    get :new
    assert_redirected_to new_user_session_path
  end

  def test_new_with_user
    sign_in user
    get :new, 'SAMLRequest' => encoded_saml
    assert_response :success
  end

  def test_new_sets_form_action_to_target
    test_new_with_user
    assert_select 'form[action=?]', request_settings.target_url
  end

  def encoded_saml
    SamlTool::Encoder.encode valid_saml_request
  end

  def valid_saml_request
    SamlTool::ErbBuilder.build(
      template: file_contents('valid_saml_request.saml.erb'),
      settings: request_settings
    )
  end

  def request_settings
    @request_settings ||= SamlTool::Settings.new(
      root_url: root_url,
      target_url: 'http://example.com/service'
    )
  end

end
