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

before do
   headers 'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
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

    QueueManager.add_user(crn_list, netid)

  end
  output
end

#returns string of waiting lists. Each waiting list is surrounded by parentheses
# with its netids inside, separated by commas
def reg_status( netid)
  waiting_lists = Registration.status( netid )

  output = ""
  for waiting_list in waiting_lists
    output +='('

    for crn in waiting_list
      if(waiting_list!=waiting_lists[0])
        output += ','
      end
      output += crn
    end

    output +=')'
  end

  output
end

options '/register' do
  200
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

options '/status' do
  200
end

get "/status" do
  netid = params[:netid]

  reg_status netid
end

post "/status" do
  netid = params[:netid]

  reg_status netid
end

#main loop
puts 'RegNow Automatic Registration Starting'
Thread.new do

  while true
    puts 'Looping ' + Time.now.to_s
    results = Registration.update_queues
    if results.size > 0
      puts "Registration Results:"
    end
    for r in results
      output = ""
      for str in r
        output += str + " "
      end
      puts output
    end

  end

end
