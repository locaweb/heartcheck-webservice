require 'heartcheck/webservice'
require 'pry-nav'
require 'fakeweb'

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
