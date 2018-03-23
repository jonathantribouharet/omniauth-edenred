# OmniAuth Edenred

[![Gem Version](https://badge.fury.io/rb/omniauth-edenred.svg)](http://badge.fury.io/rb/omniauth-edenred)

Strategy to authenticate [Edenred](https://www.edenred.fr/) in OmniAuth.

## Installation

OmniAuth Edenred is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

    gem 'omniauth-edenred', '~> 1.0'

Integrate this strategy to your OmniAuth middleware.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :edenred,
    ENV['EDENRED_CLIENT_ID'],
    ENV['EDENRED_SECRET_KEY'],
    sandbox: !Rails.env.production?,
    scope: 'openid edg-xp-mealdelivery-api offline_access',
    authorize_params: {
      acr_values: "tenant:XXXXX",
      ui_locales: 'fr-FR'
    }
  )
end
```

## Author

- [Jonathan VUKOVICH TRIBOUHARET](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

OmniAuth Edenred is released under the MIT license. See the LICENSE file for more info.
