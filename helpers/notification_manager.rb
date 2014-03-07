require 'twilio-ruby' # See: https://github.com/twilio/twilio-ruby
require 'pony'

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

  def NotificationManager.send_email_notification(email=false, crn=false)
    if !email || !crn
      return false
    end
    Pony.mail({
      :to => email,
      :via => :sendmail,
      :subject => "RegNow! #{crn} is now available.",
      :body => "#{crn} is now available. Register now: https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfreg.P_AltPin"
    })
    return true
  end
end
