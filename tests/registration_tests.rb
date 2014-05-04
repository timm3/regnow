require '../requirements'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  def test_register_from_queues()
    DatabaseManager.add_user("Test T. Name", "student_reg_test",
                    "test_password", "reg_password",
                    false, "asdf", "asdf", [])

    QueueManager.add_user(['12344','12345'],'student_reg_test')

    results = Registration.update_queues

    assert_not_nil results

    class_added = results.include?( ['student_reg_test','12344','12345'])

    assert_equal true, class_added
  end

end
