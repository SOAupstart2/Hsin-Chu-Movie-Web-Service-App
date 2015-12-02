require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  helpers AppHelpers
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride

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
    slim :history
  end

  app_get_user = lambda do
    slim :user
  end

  app_get_movie = lambda do
    @id = params[:id]
    if params[:name] || params[:time]
      @name = params[:name]
      @time = params[:time]
      request_url = "#{settings.api_server}/#{settings.api_ver}/users/#{@id}/"\
        "?name=#{@name}"
      @result = HTTParty.get(request_url)
    end
    slim :movie
  end

  app_post_user = lambda do
    request_url = "#{settings.api_server}/#{settings.api_ver}/users"

    user_form = UserForm.new(params)
    error_send(back, "Following fields are required: #{form.error_fields}") \
      unless user_form.valid?

    result = Service.new(request_url, user_form).call

    if (result.code != 200)
      flash[:notice] = 'Could not process your request'
      redirect '/users'
      return nil
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
