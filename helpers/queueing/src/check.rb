require "resque"
require "./addclasses"

idea = ARGV
puts "Analyzing your idea: #{idea.join(" ")}"
idea.each do |word|
  puts "Asking for a job to analyze: #{word}"
  sleep 10
  count = 1
#  while 1
#	if class_is_available
#		break
#	end
#  end
  Resque.enqueue(AddClasses, word)
end

