require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
	module Strategies
		class Edenred < OmniAuth::Strategies::OAuth2
		
			option :name, 'edenred'
			option :sandbox, false

			option :client_options, {
				:site => 'https://sso.auth.api.edenred.com/idsrv',
				:authorize_url => 'https://sso.auth.api.edenred.com/idsrv/connect/authorize',
				:token_url => 'https://sso.auth.api.edenred.com/idsrv/connect/token',
			}

			def setup_phase
				super

				if options[:sandbox] === true
					options[:client_options] = {
						:site => 'https://sso.auth-sandbox.api.edenred.com/idsrv',
						:authorize_url => 'https://sso.auth-sandbox.api.edenred.com/idsrv/connect/authorize',
						:token_url => 'https://sso.auth-sandbox.api.edenred.com/idsrv/connect/token',
					}
				end
			end

			# Added JWT.decode
			def callback_phase
				begin
					error = request.params["error_reason"] || request.params["error"]
					if error
						fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
					elsif !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
						fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
					else
						self.access_token = build_access_token
						self.access_token = access_token.refresh! if access_token.expired?

						@raw_info = JWT.decode(access_token.params['id_token'], nil, false).first
						env['omniauth.auth'] = auth_hash
						call_app!
					end
				rescue ::OAuth2::Error, CallbackError => e
					fail!(:invalid_credentials, e)
				rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
					fail!(:timeout, e)
				rescue ::SocketError => e
					fail!(:failed_to_connect, e)
				rescue ::JWT::DecodeError => e
					fail!(:jwt_decode, e)
				end
			end

			uid { raw_info['username'] }

			info do
				{
					:name => raw_info['username'],
					:email => raw_info['username'],
				}
			end

			extra do
				{
					'raw_info' => raw_info
				}
			end

			def raw_info
				@raw_info || {}
			end

			# Required for omniauth-oauth2 >= 1.4
			# https://github.com/intridea/omniauth-oauth2/issues/81
			def callback_url
				full_host + script_name + callback_path
			end

		end
	end
end