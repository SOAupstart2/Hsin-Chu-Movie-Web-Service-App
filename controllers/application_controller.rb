require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'
require 'slim/include'
require 'json'
require 'time'
require 'chartkick'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride
  Chartkick.options[:html] = '<div id="%{id}" style="height:500px">Loading ....</div>'
  Slim::Engine.set_options pretty: true, sort_attrs: false
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

  configure do
    Hirb.enable
    set :api_route, '/api/v1/search'
  end

  configure :development do
    set :api_server, 'http://kandianying-dymano.herokuapp.com'
  end

  configure :production, :test do
    set :api_server, 'http://kandianying-dymano.herokuapp.com'
  end

  configure :production, :development do
    enable :logging
  end

  app_get_root = lambda do
    now = DateTime.now.to_s.split('+')[0][0, 16].strip
    slim :home, locals: { now: now }
  end

  app_get_result = lambda do
    # Store user input into form object
    user_form = UserForm.new(params)

    # Get data from api
    movie_data = GetMovieData.new(
      user_form, "#{settings.api_server}#{settings.api_route}"
    ).call

    # film_info = remake_data(movie_data, user_form.search_time)
    now = DateTime.now.to_s.split('+')[0][0, 16].strip

    slim :result, locals: { user_form: user_form, film_info: movie_data,
                            now: now }
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/result/?', &app_get_result
end
