require '../app'
require 'test/unit'
require 'rack/test'

class RegNowNotificationsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RegNow
  end

  def test_text_notification
    assert_equal NotificationManager.send_text_notification("9252169095", "1"), true
  end

end


