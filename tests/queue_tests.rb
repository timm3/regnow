require '../app'
require 'test/unit'
require 'rack/test'

class RegNowUserQueueTest < Test::Unit::TestCase

  def initialize
    @crn = rand(-1000..-1).to_s
    @netid = SecureRandom.hex
  end

  def setup
    QueueManager.create_queue(@crn)
  end

  def teardown
    UserQueue.destroy_all(:crn => @crn)
  end

  def test_create_queue
    #queue = UserQueue.create(:crn => "-1337", :netids => [])
    queue = UserQueue.first(:crn => crn)
    assert_not_nil queue
  end

  def test_add_user
    QueueManager.add_user(@crn, @netid)
    queue = QueueManager.get_queue(@crn)
    assert_equal true, queue[:netids].include?(@netid)
  end

  def test_remove_user
    QueueManager.add_user(@crn, @netid)
    QueueManager.remove_user(@crn, @netid)
    queue = QueueManager.get_queue(@crn)
    assert_equal false, queue[:netids].include?(@netid)
  end

  def test_next_user
    QueueManager.add_user(@crn, @netid)
    assert_equal "student", QueueManager.get_next_user(@crn)
  end

end
