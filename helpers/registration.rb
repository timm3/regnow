module Registration

  # random value between 3-15
  def Registration.human_delay
    return rand(3..15)
  end

  # one iteration of updating all classes available and registering
  # users from queues if spots are open
  # TODO: implement timeouts for all bot action
  # TODO: implement email-only notification triggering
  # TODO: implement pool of backend threads
  def Registration.update_queues
    sleep Registration.human_delay
    current_queue = QueueManager.select_queue
    if current_queue
      queue_crn = current_queue[:crn]
      netid = current_queue[:netids].first
      user = User.first(:netid => netid)
      password = DatabaseManager.retrieve_netid_password(netid)
      $regnow_bot = CourseManager.new(netid, password)
      open_spots = $regnow.get_open_spots(queue_crn)
      if open_spots > 0 && user.text_only
        NotificationManager.send_text_notification(user.number, queue_crn)
      elsif open_spots > 0
        $regnow_bot.register(queue_crn)
        QueueManager.remove_user(queue_crn, netid)
        if current_queue[:netids].length == 0
          current_queue.destroy
        end
      end
    end
  end

end
