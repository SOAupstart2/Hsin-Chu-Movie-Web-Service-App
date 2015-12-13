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
    set :api_server, 'http://kandianying.herokuapp.com'
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
    slim :home
  end

  app_get_history = lambda do
    @input_movie_name = params[:input_movie_name]
    
    api_url = 'https://kandianying.herokuapp.com/'
    
    if @input_movie_name
      @movie_name = HTTParty.get("#{api_url}" + "api/v1/ambassador/english/38897fa9-094f-4e63-9d6d-c52408438cb6/movies")
      response  = HTTParty.get("#{api_url}" + "/api/v1/ambassador/english/38897fa9-094f-4e63-9d6d-c52408438cb6.json")
      @movie_info = response.body
    end

    slim :history
  end

  app_get_user = lambda do
    slim :user
  end

  app_get_movie = lambda do
    @id = params[:id]
    if params[:name] || params[:time]
      @result = GetMovieInfoFromAPI.new(params, settings).call
    end
    slim :movie
  end

  app_post_user = lambda do
    user_form = UserForm.new(params)
    unless user_form.valid?
      error_send(back, "Following fields are required: #{form.error_fields}")
    end
    result = SaveUserToAPI.new(settings, user_form).call
    if (result.status != 200)
      flash[:notice] = 'Could not process your request'
      redirect '/users'
    end
    redirect "/users/#{result.id}"
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/history/?', &app_get_history
  get '/users/?', &app_get_user
  get '/users/:id/?', &app_get_movie
  post '/users/?', &app_post_user
end
