require 'twilio-ruby' # See: https://github.com/twilio/twilio-ruby

module NotificationManager

  def NotificationManager.send_text_notification(number=false, crn=false)
    if !number || !crn
      return false
    end
    $twilio_client.account.messages.create(
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
