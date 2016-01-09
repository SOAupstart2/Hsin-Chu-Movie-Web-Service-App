require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'
require 'json'
require 'time'
require 'chartkick'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  helpers AppHelpers
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride
  Chartkick.options[:html] = '<div id="%{id}" style="height:380px;">Loading ....</div>'
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
    SEARCH_URL = 'http://kandianying-dymano.herokuapp.com/api/v1/search'

    # Store user input into form object
    @user_form = UserForm.new(params)

    #get data from api    
    movie_data = GetMovieData.new(params, SEARCH_URL).call
    # get_data = HTTParty.get(
    #   SEARCH_URL,
    #   body: { name: @user_form.movie_name, 
    #           time: @user_form.search_time,
    #           language: @user_form.language,
    #           location: @user_form.location
    #         }.to_json
    # )
    
    @film_info = remake_data(movie_data, @user_form.search_time)
    @today = Date.today
    @max_day = @today + 4

    slim :result
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/result/?', &app_get_result
end
