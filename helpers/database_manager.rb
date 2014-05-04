module DatabaseManager

  #add a new course to the databse
  def DatabaseManager.add_course(title="", credit_hours=0, term="",
                                  subject="", year="", crns=[], description="",
                                  code="", course_id="")
    course = Course.create(:title => title, :credit_hours => credit_hours,
                            :term => term, :subject => subject, :year => year,
                            :crns => crns, :description => description,
                            :code => code, :course_id => course_id)
    course.save
  end

  #delete course with given CRN from database
  def DatabaseManager.remove_course(crn)
    # TODO: implement
    Course.find_each() do |course|
      if course[:crns].include?(crn.to_s)
        course.delete
      end
    end

  end

  #check if given CRN exists in database
  def DatabaseManager.check_crn(crn)
    Course.find_each() do |course|
      if course[:crns].include?(crn.to_s)
        return true
      end
    end

    return false
  end

  #add user to database
  def DatabaseManager.add_user(name="", netid="", password="",
                                  adPassword="", regnow=false, salt="",
                                  adSalt="", crns=[])
    user = User.create(:name => name, :netid => netid, :password => password,
                        :adPassword => adPassword, :regnow => regnow,
                        :salt => salt, :adSalt => adSalt, :crns => crns)
    user.save
  end

  #get the netID password corresponding to that netID
  def DatabaseManager.retrieve_netid_password(netid)
    user = User.first(:netid => netid)
    if user == nil
      return false
    end
    return user.adPassword
  end

  #remove user from database that has given netid
  def DatabaseManager.remove_user(net_id)
    User.find_each() do |user|
      if user[:netid] == net_id
        user.delete
      end
    end
  end

  #check if given netid exists
  def DatabaseManager.check_netid(net_id)
    User.find_each() do |user|
      if user[:netid] == net_id
        return true
      end
    end

    return false
  end

  #delete all courses from database
  def DatabaseManager.reset_database()
    Course.delete_all
  end
end
