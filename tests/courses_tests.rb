require '../app'
require 'test/unit'
require 'rack/test'

class RegNowCoursesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RegNow
  end

  def test_my_default
    get '/'
    assert_equal 'Hello world!', last_response.body
  end

  def test_get_num_spots
  	test_bot = CourseManager.new
  	num_spots = test_bot.get_num_spots(48263)
  	assert_equal num_spots, 0
  end
end
