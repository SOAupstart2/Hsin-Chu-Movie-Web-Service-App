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
    @max_day = @today + 2

    slim :home
  end

  app_get_result = lambda do
    USERS_URL = 'http://kandianying-dymano.herokuapp.com/api/v1/users'

    # Store user input into form object
    user_form = UserForm.new(params)

    # Get user ID by using service object
    user_id = GetUserID.new(params, USERS_URL).call

    # Escape URL to handle Chinese input
    escaped_url = URI.escape(USERS_URL + "/#{user_id}" + "?name=#{user_form.movie_name}&time=#{user_form.search_time}")

    @get_data = HTTParty.get(escaped_url)
    @film_info = []

    @get_data["search_name"].each do |cinema, movies|
      movies.each do |movie, dates|
        dates.each do |date, times|
          times.each do |time|
            start_time = Time.parse(date+' '+time)
            end_time = start_time + 5400
            if (start_time - Time.parse(user_form.search_time)).between?(0,86400)
              @film_info << [ movie, cinema, start_time.to_s.chomp(" +0800"), end_time.to_s.chomp(" +0800")]
            end
          end
        end
      end
    end
    @user_form = user_form
    @today = Date.today
    @max_day = @today + 2

    slim :result
  end

  # Web App Views Routes
  get '/', &app_get_root
  get '/result/?', &app_get_result
end
