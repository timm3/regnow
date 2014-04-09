require '../app'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  def initialize
    @crn = rand(-1000..-1).to_s
    @netid = SecureRandom.hex
    @course = SecureRandom.hex
    @subject = SecureRandom.hex
    @professor = SecureRandom.hex
    @password = SecureRandom.hex
    @netid_password = SecureRandom.hex
    @date = DateTime.now
  end

  def test_add_course
    DatabaseManager.add_course(@course, [@crn], @subject, @professor)
    assert_equal true, DatabaseManager.check_crn(@crn)
  end

  def test_delete_course
    DatabaseManager.remove_course(@crn)
    assert_equal false, DatabaseManager.check_crn(@crn)
  end

  def test_add_user
    DatabaseManager.add_user(SecureRandom.hex, @netid, @password,
                              @netid_password, @date, false, false, "", [] )
    assert_equal true, DatabaseManager.check_netid("student2")
  end

  def test_delete_user
    DatabaseManager.remove_user(@netid)
    assert_equal false, DatabaseManager.check_netid(netid)
  end

end
