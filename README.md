# Heartcheck::Webservice

[![Build Status](https://travis-ci.org/locaweb/heartcheck-webservice.svg)](https://travis-ci.org/locaweb/heartcheck-webservice)

A plugin to check webservice connection with heartcheck

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heartcheck-webservice'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartcheck-webservice

## Usage

You can add a check to a webservice when configuring heartcheck

The service is a Hash that needs to respond to `:name` to identify the service, `:url` of the service (GET request) and `:body_match` is a regex that is going to match the response body.
Ex.

```ruby
Heartcheck.setup do |config|
  config.add :webservice do |c|
    c.add_service(name: 'CloudApi', url: "http://cloud.example.com/status", body_match: /OK/)
  end
end
```

## Contributing

1. Fork it ( https://github.com/locaweb/heartcheck-webservice )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
