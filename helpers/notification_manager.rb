require 'twilio-ruby' # See: https://github.com/twilio/twilio-ruby
require 'mail'

module NotificationManager

  def NotificationManager.send_text_notification(number=false, crn=false)
    if !number || crn
      return false
    end
    client = Twilio::REST::Client.new($twilio_account_sid, $twilio_auth_token)
    client.account.message.create(
      :from => '+14158304303',
      :to => "+1" + number,
      :body => "RegNow! Your course CRN #{crn} now has a spot open!"
    )
    return true
  end

  def NotificationManager.send_email_notification(user, crn)
    # TODO
  end
end
