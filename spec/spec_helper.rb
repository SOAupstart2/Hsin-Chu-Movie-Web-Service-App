ENV['RACK_ENV'] = 'test'

Dir.glob('./{helpers,controllers,forms,services,values}/*.rb').each do |file|
  require file
end
require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'watir-webdriver'
require 'headless'

include Rack::Test::Methods

def app
  ApplicationController
end
