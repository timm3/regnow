module QueueManager

  def QueueManager.create_queue(crn)
    queue = Queue.create(:crn => crn, :netids => [])
    queue.save
  end

  def QueueManager.add_user(crn, netid)
    queue = Queue.first(:crn => crn)
    if queue == nil
      queue = QueueManager.create_queue(crn)
    end
    if !queue.netids.include?(netid)
      queue.netids << netid
      queue.save
      return true
    end
    return false
  end

  def QueueManager.remove_user(crn, netid)
    queue = Queue.first(:crn => crn)
    if queue == nil
      return false
    end
    if queue.netids.delete(netid) == nil
      queue.save
      return false
    else
      return true
    end
  end

  def QueueManager.get_next_user(crn)
    queue = Queue.first(:crn => crn)
    if queue == nil
      return nil
    end
    return queue.netids.first
  end

end
