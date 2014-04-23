module Registration

  # random value between 2-6
  def Registration.human_delay
    return 2+rand(5)
  end

  # one iteration of updating all classes available and registering
  # users from queues if spots are open
  #
  # TODO: implement email-only notification triggering
  def Registration.update_queues
    sleep Registration.human_delay
    all_queues = QueueManager.get_all_queues

    regnow_bot = CourseManager.new

    for current_queue in all_queues
      crn_list = current_queue[:crn]

      open_spots = regnow_bot.get_open_spots(queue_crn)
      for i in 0..open_spots
        current_user = QueueManager.get_next_user(crn_list)
        if(current_user == nil)
          break
        end

        netid = current_user[:netid]
        user_bot = CourseManager.new( netid, current_user[:password])
        reg_success = user_bot.register(crn_list)

        msg = ''
        if reg_success
          msg += 'SUCCESS: '

        #registration failed for user
        else
          msg += 'FAILURE: '
        end

        msg += 'Register ' + netid + ' for CRNs: '
        for crn in crn_list
          msg += crn + ' '
        end
        puts msg

        QueueManager.remove_user_from_queue( current_queue , netid)
      end

      #queue is empty, so we don't need to be checking it anymore
      if current_queue[:netids].length == 0
        current_queue.destroy
      end

    end
  end

end
