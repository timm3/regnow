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

  def test_my_default
    get '/'
    assert_equal 'Hello world!', last_response.body
  end

  def test_get_open_spots
  	open_spots = @test_bot.get_open_spots(48263)
  	assert_equal open_spots, 0
  end

  def test_get_total_spots
  	total_spots = @test_bot.get_total_spots(48263)
    assert_equal total_spots, 32
  end
end
