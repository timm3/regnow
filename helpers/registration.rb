module Registration

  # random value between 2-6
  def Registration.human_delay
    #return 2+rand(5)
    return 0
  end

  #return an array of queues that this netid is waitlisted for,
  # each queue is represented as an array of CRNs
  def Registration.status( netid )
    waiting_array = Array.new

    all_queues = QueueManager.get_all_queues
    for current_queue in all_queues
      if current_queue[:netids].include?(netid)
        waiting_array.push( current_queue[:crn] )
      end
    end

    return waiting_array
  end

  # one iteration of updating all classes available and registering
  # users from queues if spots are open
  #
  # TODO: implement email-only notification triggering
  def Registration.update_queues
    changes = Array.new

    sleep Registration.human_delay
    all_queues = QueueManager.select_all

    if all_queues==nil
      return nil
    end

    regnow_bot = CourseManager.new

    for current_queue in all_queues
      crn_list = current_queue[:crn]

      min_open_spots = 1000000
      for queue_crn in crn_list
        open_spots = regnow_bot.get_open_spots(queue_crn)

        if open_spots < min_open_spots
          min_open_spots = open_spots
        end
      end

      for i in 0..min_open_spots

        netid= current_queue[:netids].first
        if(netid == nil)
          break
        end

        password = DatabaseManager.retrieve_netid_password(netid)
        user_bot = CourseManager.new( netid, password)

        reg_success = user_bot.register_crn_list crn_list

        msg = ''
        if reg_success
          msg += 'SUCCESS: '

          changes.push( [netid] + crn_list)

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

    return changes
  end

end
