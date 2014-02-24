class RegNow < Sinatra::Application
	get "/" do
		@course = Course.create(:name => "Physics 212", :crn => 12345, :code => "PhYS212", :instructor => "Mason")
		@course.save
		"Hello world!"
	end
end