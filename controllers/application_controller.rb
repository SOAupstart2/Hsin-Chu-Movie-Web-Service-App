require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'
require 'json'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  helpers AppHelpers
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride

  Slim::Engine.set_options pretty: true, sort_attrs: false
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

  configure do
    Hirb.enable
    set :api_ver, 'api/v1'
  end

  configure :development, :test do
    set :api_server, 'http://localhost:9292'
  end

  configure :production do
    set :api_server, 'http://kandianying-dymano.herokuapp.com'
  end

  configure :production, :development do
    enable :logging
  end

  app_get_root = lambda do
    @today = Date.today
    @max_day = @today + 4

    slim :home
  end

  app_get_result = lambda do
    USERS_PAGE_URL = 'http://kandianying-dymano.herokuapp.com/api/v1/users'
    user_form = UserForm.new(params)

    # Register user location and language, and get the response
    post_response = HTTParty.post(
      USERS_PAGE_URL,
      body:{
        location:user_form.location, language:user_form.language
      }.to_json
    )

    # Escape to handle Chinese input
    escaped_url = URI.escape(
      USERS_PAGE_URL + \
      "/#{post_response['user_info']['id']}" \
      "?name=#{user_form.movie_name}&time=#{user_form.search_time}"
    )

    @film_info = HTTParty.get(escaped_url)

    slim :result
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/result/?', &app_get_result
end
