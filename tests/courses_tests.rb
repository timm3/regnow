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
end
