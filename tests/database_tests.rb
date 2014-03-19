require '../app'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  def test_add_course()
    DatabaseManager.add_course("test course", ["-1337"], "TST", "Test Professor")
    assert_equal true, DatabaseManager.check_crn("-1337")
  end

  def test_delete_course()
    DatabaseManager.remove_course("-1337")
    assert_equal false, DatabaseManager.check_crn("-1337")
  end

  def test_add_user()
    DatabaseManager.add_user( "Test T. Name", "student2", "test_password", "test_netid_password",
                              DateTime.now, false, false, "", [] )
    assert_equal true, DatabaseManager.check_netid("student2")
  end

  def test_delete_user()
    DatabaseManager.remove_user("student2")
    assert_equal false, DatabaseManager.check_netid("student2")
  end

end
