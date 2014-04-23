module QueueManager

  def QueueManager.create_queue(crn_list)
    queue = UserQueue.create(:crn => crn_list.sort, :netids => [])
    queue.save
  end

  def QueueManager.get_queue(crn_list)
    queue = UserQueue.first(:crn => crn_list.sort)
    return queue
  end

  def QueueManager.reset
    UserQueue.delete_all
  end

  def QueueManager.select_all
    return UserQueue.all
  end

  def QueueManager.add_user(crn_list, netid)
    queue = UserQueue.first(:crn => crn_list.sort)
    if queue == nil
      queue = QueueManager.create_queue(crn_list.sort)
    end
    if !queue[:netids].include?(netid)
      queue[:netids] << netid
      queue.save
      return true
    end
    return false
  end

  def QueueManager.remove_user(crn_list, netid)
    queue = UserQueue.first(:crn => crn_list.sort)
    remove_user_from_queue(queue, netid)
  end

  def QueueManager.remove_user_from_queue(queue, netid)
    if queue == nil
      return false
    end
    if queue.netids.delete(netid) == nil
      queue.save
      return false
    else
      queue.save
      return true
    end
  end

  def QueueManager.get_next_user(crn_list)
    queue = UserQueue.first(:crn => crn_list.sort)
    if queue == nil
      return nil
    end
    return queue[:netids].first
  end

end
