require 'sinatra'
require 'mongo_mapper'
require 'securerandom'

require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'
require_relative 'config/db'
require_relative 'mock/main'

class RegNow < Sinatra::Application
  $regnow_bot = CourseManager.new

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

threads = RegNowThreads.new(5)
Thread.new do # TODO: process course search queue
  while true do
     Registration.update_queues
  end
end
