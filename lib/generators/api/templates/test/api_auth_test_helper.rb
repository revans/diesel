# AuthorizationHelper
#
# use in api tests:
#
# e.g.
#
# include AuthorizationHelper
#
# setup { add_auth_token_to_header }
#
#
module ApiAuthTestHelper
  def add_auth_token_to_header(token = api_token)
    @request.env["HTTP_AUTHORIZATION"] = token
  end

  # def authorization_token
  #   @authorization_token ||= ::ActionController::HttpAuthentication::Token.encode_credentials(api_token)
  # end

  def api_token
    @api_token ||= ::Rails.configuration.x.api_token
  end
end
