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

  def test_email_notification
    email = "perry.huang@gmail.com"
    assert_equal NotificationManager.send_email_notification(email, "1"), true
  end
end


