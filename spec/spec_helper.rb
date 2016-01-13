ENV['RACK_ENV'] = 'test'

Dir.glob('./{helpers,controllers,forms,services,values}/*.rb').each do |file|
  require file
end
Dir.glob('./spec/pages/*.rb').each { |file| require file }

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'watir-webdriver'
require 'headless'
require 'page-object'
require 'vcr'
require 'date'
require 'time'
require 'securerandom'

include Rack::Test::Methods

def app
  ApplicationController
end
