
require 'sinatra'
require 'sinatra/activerecord'
require_relative '../config/environments'

class User < ActiveRecord::Base
end
