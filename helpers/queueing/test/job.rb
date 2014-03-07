require 'resque'
require 'resque_unit'

class MyJob
  @queue = :testing 

  def self.perform(x)
	puts "Hello world!!"
  end
end

def queue_job
  Resque.enqueue(MyJob, 1)
end
