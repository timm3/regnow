require '../app'
require 'test/unit'
require 'rack/test'

class RegNowCoursesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RegNow
  end

  def setup
    @test_bot = CourseManager.new
  end

  def test_get_open_spots
    open_spots = @test_bot.get_open_spots(52738)
    assert_equal open_spots, 3
  end

  def test_get_total_spots
    total_spots = @test_bot.get_total_spots(52738)
    assert_equal total_spots, 12
  end

  def test_register_invalid_course
    result = @test_bot.register_course(1)
    assert_equal result, false
  end

  def test_register_valid_course
    result = @test_bot.register_course(52738)
    assert_equal result, true
  end

  def test_environment
    assert_equal $environment, "development"
  end
end


