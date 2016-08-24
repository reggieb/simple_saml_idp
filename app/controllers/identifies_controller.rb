class IdentifiesController < ApplicationController
  before_action :authenticate_user!

  # TODO Need to add handling of RelayState
  #      http://stackoverflow.com/questions/34350160/what-is-exactly-relaystate-paramerter-used-in-sso-ex-saml
  def new
    request_data = SamlTool::Decoder.decode(params['SAMLRequest'])
    @saml_request = SamlRequestReader.new(request_data)
    @target = @saml_request.assertion_consumer_service_url
    Rails.logger.warn "Target is #{Rails.logger.info}"
    saml = SamlTool::ErbBuilder.build(
      template: saml_response_template,
      settings: response_settings
    )
    unsigned_assertion = Xmldsig::SignedDocument.new(saml)
    signed_assertion = unsigned_assertion.sign(open_ssl_rsa_key)

    response_saml = SamlTool::ResponseReader.new(signed_assertion)
    Rails.logger.info "Response valid? #{response_saml.valid?}"

    @saml_response = SamlTool::Encoder.encode(signed_assertion)
  end

  private
  def saml_response_template
    contents_of('identifies/response.saml.erb', location: view_paths.first)
  end

  def response_settings
    @response_settings ||= SamlTool::Settings.new(
      issuer: root_url,
      name_id: current_user.email,
      not_on_or_after: 10.minutes.from_now.utc.iso8601,
      request: @saml_request,
      certificate: certificate,
      rsa_key: rsa_key,
      attributes: {
        email: current_user.email
      }
    )
  end

  def certificate
    @certificate ||= SamlTool::Certificate.new(x509_certificate)
  end

  def rsa_key
    @rsa_key ||= SamlTool::RsaKey.new(open_ssl_rsa_key)
  end


  def x509_certificate
    @x509_certificate ||= OpenSSL::PKCS12.new(
      contents_of('app/demo_identity/usercert.p12'),
      'hello'
    ).certificate
  end

  def open_ssl_rsa_key
    @open_ssl_rsa_key ||= OpenSSL::PKey::RSA.new(
      contents_of('app/demo_identity/userkey.pem'),
      'hello'
    )
  end

end
