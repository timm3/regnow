module QueueManager

  def QueueManager.create_queue(crn)
    queue = UserQueue.create(:crn => crn, :netids => [])
    queue.save
  end

  def QueueManager.get_queue(crn)
    queue = UserQueue.first(:crn => crn)
    return queue
  end

  def QueueManager.add_user(crn, netid)
    queue = UserQueue.first(:crn => crn)
    if queue == nil
      queue = QueueManager.create_queue(crn)
    end
    if !queue[:netids].include?(netid)
      queue[:netids] << netid
      queue.save
      return true
    end
    return false
  end

  def QueueManager.remove_user(crn, netid)
    queue = UserQueue.first(:crn => crn)
    if queue == nil
      return false
    end
    if queue.netids.delete(netid) == nil
      return false
    else
      queue.save
      return true
    end
  end

  def QueueManager.get_next_user(crn)
    queue = UserQueue.first(:crn => crn)
    if queue == nil
      return nil
    end
    return queue[:netids].first
  end

end
