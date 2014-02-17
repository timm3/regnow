require 'sinatra'

configure do
  set :bind, '0.0.0.0'
  set :public_folder, Proc.new { File.join(root, "static") }
  set :server, "puma"
  set :views
  set :port, 80
  set :environment, :development
end

get '/hi' do
  "Hello World!"
end
