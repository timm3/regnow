module UnitTests

	def test_job_queued
 		queue_job
  		assert_queued(MyJob)
	end

	def test_job_queued_with_arguments
 		queue_job
 		assert_queued(MyJob, [1])
	end

	def test_job_runs 
  		queue_job 
  		Resque.run!
  		assert_equal "Hello world!!!" , "Job didn't run"
	end

end	
