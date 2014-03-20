require '../app'
require 'test/unit'
require 'rack/test'

class RegNowUserQueueTest < Test::Unit::TestCase

  def setup
    QueueManager.create_queue("-1337")
  end

  def teardown
    UserQueue.destroy_all(:crn => "-1337")
  end

  def test_create_queue
    #queue = UserQueue.create(:crn => "-1337", :netids => [])
    queue = UserQueue.first(:crn => "-1337")
    assert_not_nil queue
  end

  def test_add_user
    QueueManager.add_user("-1337", "student")
    queue = QueueManager.get_queue("-1337")
    assert_equal true, queue[:netids].include?("student")
  end

  def test_remove_user
    QueueManager.add_user("-1337", "student")
    QueueManager.remove_user("-1337", "student")
    queue = QueueManager.get_queue("-1337")
    assert_equal false, queue[:netids].include?("student")
  end

  def test_next_user
    QueueManager.add_user("-1337", "student")
    assert_equal "student", QueueManager.get_next_user("-1337")
  end

end
