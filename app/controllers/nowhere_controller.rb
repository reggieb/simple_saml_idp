class NowhereController < ApplicationController

  def create
    saml = SamlTool::ErbBuilder.build(
      template: saml_request_template,
      settings: request_settings
    )

    encoded_saml = SamlTool::Encoder.encode(saml)

    redirect_uri = SamlTool::Redirect.uri(
      to: request_settings.idp_sso_target_url,
      data: {
        'SAMLRequest' => encoded_saml
      }
    )

    redirect_to redirect_uri
  end

  def update
    request_data = SamlTool::Decoder.decode(params['SAMLResponse'])
    response_saml = SamlTool::ResponseReader.new(request_data)
    @response_valid = response_saml.valid?
  end

  private

  def saml_request_template
    contents_of 'nowhere/request.saml.erb', location: view_paths.first
  end

  def request_settings
    @request_settings ||= SamlTool::Settings.new(
      assertion_consumer_service_url: 'http://localhost:3000/nowhere/1',
      issuer:                         'http://localhost:3000',
      idp_sso_target_url:             'http://localhost:3000/identify/new'
    )
  end
end
