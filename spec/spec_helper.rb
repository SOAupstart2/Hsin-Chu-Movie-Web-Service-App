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

include Rack::Test::Methods

def app
  ApplicationController
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassette'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

def yml_load(file)
  YAML.load(File.read(file))
end