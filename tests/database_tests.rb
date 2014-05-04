require '../requirements'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  def test_add_course()
    DatabaseManager.add_course("test", [5], term="fall",
                                    subject="Asian American Studies",
                                    year="2001", crns=["-1337"],
                                    description="test description",
                                    code="AAS", course_id="242")
    assert_equal true, DatabaseManager.check_crn("-1337")
  end

  def test_delete_course()
    DatabaseManager.remove_course("-1337")
    assert_equal false, DatabaseManager.check_crn("-1337")
  end

  def test_add_user
    DatabaseManager.add_user("Test T. Name", "student2",
                    "test_password", "test_netid_password",
                    false, "asdf", "asdf", [])
    assert_equal true, DatabaseManager.check_netid("student2")
  end

  def test_user_password
    password = DatabaseManager.retrieve_netid_password("student2")
    assert_equal "test_netid_password", password
  end

  #def test_delete_user()
  #  DatabaseManager.remove_user("student2")
  #  assert_equal false, DatabaseManager.check_netid("student2")
  #end

end
