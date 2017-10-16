# Heartcheck::Webservice

[![Build Status](https://travis-ci.org/locaweb/heartcheck-webservice.svg)](https://travis-ci.org/locaweb/heartcheck-webservice)
[![Ebert](https://ebertapp.io/github/locaweb/heartcheck-webservice.svg)](https://ebertapp.io/github/locaweb/heartcheck-webservice)

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

Here is an example using all available options:

```ruby
Heartcheck.setup do |config|
  config.add :webservice do |c|
    c.add_service(name: 'CloudApi',
                  url: "https://cloud.example.com/status",
                  proxy: "10.20.30.40:8888",
                  headers: { "MY-API-KEY" => "abc123" },
                  body_match: /OK/,
                  ignore_ssl_cert: true,
                  open_timeout: 2,
                  read_timeout: 60)
  end
end
```

### Default values

| Option          | Value |
|-----------------|-------|
| open_timeout    | 3s    |
| read_timeout    | 5s    |
| ignore_ssl_cert | false |

## Contributing

1. Fork it ( https://github.com/locaweb/heartcheck-webservice )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
