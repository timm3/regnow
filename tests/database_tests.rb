require '../app'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  class << self
    def setup
      @crn = rand(-1000..-1).to_s
      @title = SecureRandom.hex
      @year = SecureRandom.hex
      @term = SecureRandom.hex
      @course_id = SecureRandom.hex
      @description = SecureRandom.hex
      @netid = SecureRandom.hex
      @course = SecureRandom.hex
      @subject = SecureRandom.hex
      @professor = SecureRandom.hex
      @password = SecureRandom.hex
      @netid_password = SecureRandom.hex
      @date = DateTime.now
    end
  end

=begin
  def test_add_course
      DatabaseManager.add_course(title=@title, credit_hours="0", term=@term,
                                subject=@subject, year=@year, crns=[],
                                description=@description,
                                code=@subject, course_id=@course_id)
      assert_equal true, DatabaseManager.check_crn(@crn)

  end
=end

  def test_delete_course
    DatabaseManager.remove_course(@crn)
    assert_equal false, DatabaseManager.check_crn(@crn)
  end

  def test_add_user
    DatabaseManager.add_user(SecureRandom.hex, @netid, @password,
                              @netid_password, @date, false, false, "", [] )
    assert_equal true, DatabaseManager.check_netid(@netid)
  end

  def test_delete_user
    DatabaseManager.remove_user(@netid)
    assert_equal false, DatabaseManager.check_netid(@netid)
  end

end
