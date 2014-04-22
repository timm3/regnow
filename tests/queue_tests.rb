require '../app'
require 'test/unit'
require 'rack/test'
require 'securerandom'

class RegNowUserQueueTest < Test::Unit::TestCase

  class << self
    def setup
      @crn_list = [rand(-1000..-1).to_s,rand(-1000..-1).to_s]
      @netid = SecureRandom.hex
    end
  end

  def setup
    QueueManager.create_queue(@crn_list)
  end

  def teardown
    UserQueue.destroy_all(:crn => @crn_list.asc)
  end

  def test_create_queue
    queue = UserQueue.first(:crn => @crn_list.asc)
    assert_not_nil queue
  end

  def test_add_user
    QueueManager.add_user(@crn_list, @netid)
    queue = QueueManager.get_queue(@crn_list)
    assert_equal true, queue[:netids].include?(@netid)
  end

  def test_remove_user
    QueueManager.add_user(@crn_list, @netid)
    QueueManager.remove_user(@crn_list, @netid)
    queue = QueueManager.get_queue(@crn_list)
    assert_equal false, queue[:netids].include?(@netid)
  end

  def test_next_user
    QueueManager.add_user(@crn_list, @netid)
    assert_equal @netid, QueueManager.get_next_user(@crn_list)
  end

end
