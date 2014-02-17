require 'sinatra'

configure do
  set :bind, '0.0.0.0'
  set :server, "puma"
  set :port, 8080
  set :environment, :development
end

get '/' do
  "Hello world"
end
