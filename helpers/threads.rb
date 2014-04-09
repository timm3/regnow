class RegNowThreads

  def initialize(num_threads=1)
    @threads = Array.new(num_threads)
    @current_queue
  end
end
