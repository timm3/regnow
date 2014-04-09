module Registration

  # random value between 3-15
  def human_delay
    return rand(3..15)
  end

  # one iteration of updating all classes available and registering
  # users from queues if spots are open
  # TODO: implement timeouts for all bot action
  # TODO: implement registration-only notification triggering
  def update_queues
    sleep human_delay
    current_queue = QueueManager.select_queue
    if current_queue
      queue_crn = current_queue[:crn]
      netid = current_queue[:netids].first
      password = DatabaseManager.retrieve_netid_password(netid)
      $regnow_bot = CourseManager.new(netid, password)
      if $regnow_bot.get_open_spots(queue_crn) > 0
        $regnow_bot.login
        $regnow_bot.choose_latest_semester
        $regnow_bot.register(queue_crn)
        QueueManager.remove_user(crn, netid)
        if current_queue[:netids].length == 0
          current_queue.destroy
        end
      end
    end
  end

end
