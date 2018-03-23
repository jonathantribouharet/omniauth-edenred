require File.expand_path("../lib/omniauth-edenred/version", __FILE__)

Gem::Specification.new do |gem|
	gem.name = "omniauth-edenred"
	gem.summary = "OmniAuth Strategy for Edenred via OAuth2"
	gem.description = "OmniAuth Strategy for Edenred via OAuth2"
	gem.homepage = "https://github.com/jonathantribouharet/omniauth-edenred"
	gem.version = OmniAuth::Edenred::VERSION
	gem.files = `git ls-files`.split("\n")
	gem.require_paths = ["lib"]
	gem.authors = ['Jonathan VUKOVICH TRIBOUHARET']
	gem.email = 'jonathan.tribouharet@gmail.com'
	gem.license = 'MIT'
	gem.platform = Gem::Platform::RUBY
	
	gem.add_dependency 'omniauth-oauth2', '~> 1.4'
	gem.add_dependency 'jwt'
end
