require 'sinatra'

class RegNow < Sinatra::Application
  enable :sessions

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

require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'