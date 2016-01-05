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

  helpers do
    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end
  end

  app_get_root = lambda do
    @today = Date.today
    @max_day = @today + 4

    slim :home
  end

  app_get_result = lambda do
    language_input = params[:language]
    location_input = params[:location]
    movie_name = params[:movie_name]
    search_time = params[:search_time]

    USERS_URL = 'http://kandianying-dymano.herokuapp.com/api/v1/users'

    user_post_response = HTTParty.post(
      USERS_URL,
      body:{
        location:location_input, language:language_input
      }.to_json
    )

    user_id = user_post_response["user_info"]["id"]

    begin
      @film_info = HTTParty.get(USERS_URL + "/#{user_id}?name=#{movie_name}&time=#{search_time}")
    rescue
      @film_info = "Invalid input. Please enter movie name in English."
    end

    slim :result
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/result/?', &app_get_result
end
