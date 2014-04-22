require '../app'
require 'test/unit'
require 'rack/test'

class RegNowCoursesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RegNow
  end

  def setup
    @test_bot = CourseManager.new('student1','test')
  end

  def test_get_open_spots
    open_spots = @test_bot.get_open_spots("52738")
    assert_equal 3, open_spots
  end

  def test_get_total_spots
    total_spots = @test_bot.get_total_spots("52738")
    assert_equal 10, total_spots
  end

  def test_register_invalid_course
    result = @test_bot.register_crn_list(["11111"])
    assert_equal false, result
  end

  def test_register_valid_course
    result = @test_bot.register_crn_list(["12344","12345"])
    assert_equal true, result
  end

  def test_course_crns
    Course.find_each() do |course|
      contains = course[:crns].length > 0
      #if !contains
      #  next
      #end
      assert_equal contains, true
    end
  end

  def test_environment
    assert_equal $environment, "development"
  end
end
