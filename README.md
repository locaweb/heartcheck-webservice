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

The service is a Hash that needs to respond to `:name` to identify the service and `:url` of the service (GET request).
Ex.

```ruby
Heartcheck.setup do |config|
  config.add :webservice do |c|
    c.add_service(name: 'CloudApi', url: "http://cloud.example.com/status")
  end
end
```

### Other available options for the service Hash

*   body_match
    *   A regex that is going to match the response body
*   ignore_ssl_cert
    *   When set to `true` the SSL certificate won't be verified
*   open_timeout
    *   Number of seconds to wait for the connection to open
*   read_timeout
    *   Number of seconds to wait for one block to be read

### Here is an example using all available options:

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

## Development setup using Docker

The Docker Hearthcheck-Webservice provides a container with the current stable version of Ruby and requires you to have these tools available in your local environment:

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)
-   [Bash](https://www.gnu.org/software/bash/)

#### BootStrap Script to run the dockerized environment

```bash
./scripts/heartcheck-resque setup
```

Run the command `./scripts/heartcheck-webservice -h` to see available options.

## Contributing

1.  [Fork it](https://github.com/locaweb/heartcheck-webservice/fork)
2.  Create your feature branch ( **git checkout -b my-new-feature** )
3.  Commit your changes ( **git commit -am 'Add some feature'** )
4.  Push to the branch ( **git push origin my-new-feature** )
5.  Create a new Pull Request

## License

*   [MIT License](https://github.com/locaweb/heartcheck-webservice/blob/master/LICENSE.txt)
