require 'sinatra'

configure do
  set :bind, '0.0.0.0'
  set :public_folder, Proc.new { File.join(root, "static") }
  set :server, "puma"
  set :port, "80"
  set :environment, :development
end

get '/' do
  "Hello world"
end
