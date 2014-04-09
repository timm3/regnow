require 'sinatra'
require 'mongo_mapper'

class RegNow < Sinatra::Application
  configure do
    set :bind, '0.0.0.0'
    set :server, "puma"
    set :port, 8080
    set :environment, :development
  end

  helpers do
    include Rack::Utils
  end
end

Thread.new do # TODO: process course search queue
  while true do
     sleep 60
  end
end

require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'
require_relative 'config/db'
require_relative 'mock/main'
