require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rspec/autorun'
require 'kmandrup-colorist'
require 'style_converter'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include(Matchers)  
end