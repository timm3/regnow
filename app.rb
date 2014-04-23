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

def auto_register(netid, crn_str)
  output = ""

  if netid == nil || crn_str == nil
    output = "error with input"
  else
    crn_list = crn_str.split(",")

    output += "Netid :"+ netid + " CRNs: "

    #TODO validate netid, add user with this netid to queue

    for crn in crn_list
      output += crn + " "
    end
  end
  output
end

get "/register" do
  netid = params[:netid]
  crn_str = params[:crns]

  auto_register netid, crn_str
end

post "/register" do
  netid = params[:netid]
  crn_str = params[:crns]

  auto_register netid, crn_str
end

threads = RegNowThreads.new(5)
Thread.new do # TODO: process course search queue
  while true do
     Registration.update_queues
  end
end
