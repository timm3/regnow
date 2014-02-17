require 'sinatra'

configure do
  set :bind, '0.0.0.0'
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/hi' do
  "Hello World!"
end
