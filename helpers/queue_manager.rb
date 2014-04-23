module QueueManager

  def QueueManager.create_queue(crn_list)
    queue = UserQueue.create(:crn => crn_list.asc, :netids => [])
    queue.save
  end

  def QueueManager.get_queue(crn_list)
    queue = UserQueue.first(:crn => crn_list.asc)
    return queue
  end

  def QueueManager.reset
    UserQueue.delete_all
  end

  def QueueManager.select_all
    return UserQueue.find()
  end

  def QueueManager.select_queue
    queue = UserQueue.first(:order => :crn.asc)
    return queue
  end

  def QueueManager.add_user(crn_list, netid)
    queue = UserQueue.first(:crn => crn_list.asc)
    if queue == nil
      queue = QueueManager.create_queue(crn_list)
    end
    if !queue[:netids].include?(netid)
      queue[:netids] << netid
      queue.save
      return true
    end
    return false
  end

  def QueueManager.remove_user(crn_list, netid)
    queue = UserQueue.first(:crn => crn_list.asc)
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
    queue = UserQueue.first(:crn => crn_list.asc)
    if queue == nil
      return nil
    end
    return queue[:netids].first
  end

end
