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
				@raw_info ||= JWT.decode(access_token.params['id_token'], nil, false).first
			end

			# Required for omniauth-oauth2 >= 1.4
			# https://github.com/intridea/omniauth-oauth2/issues/81
			def callback_url
				full_host + script_name + callback_path
			end

		end
	end
end