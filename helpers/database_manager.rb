module DatabaseManager

  def DatabaseManager.add_course(title="", credit_hours=0, term="",
                                  subject="", year="", crns=[], description="",
                                  code="", course_id="")
    course = Course.create(:title => title, :credit_hours => credit_hours,
                            :term => term, :subject => subject, :year => year,
                            :crns => crns, :description => description,
                            :code => code, :course_id => course_id)
    course.save
  end

  def DatabaseManager.remove_course(crn)
    # TODO: implement
    Course.find_each() do |course|
      if course[:crns].include?(crn.to_s)
        course.delete
      end
    end

  end

  def DatabaseManager.check_crn(crn)
    Course.find_each() do |course|
      if course[:crns].include?(crn.to_s)
        return true
      end
    end

    return false
  end

  def DatabaseManager.add_user(name="", netid="", password="",
                                  netid_password="", join_date="",
                                  text_only=false, email_only=false,
                                  number=0, crns=[])
    user = User.create( :name => name, :netid => netid, :password => password,
                        :netid_password => netid_password,
                        :join_date => join_date, :text_only => text_only,
                        :email_only => email_only , :number => number,
                        :crns => crns)
    user.save
  end

  def DatabaseManager.retrieve_netid_password(netid)
    user = User.first(:netid => netid)
    return user[:netid_password]
  end

  def DatabaseManager.remove_user(net_id)
    User.find_each() do |user|
      if user[:netid] == net_id
        user.delete
      end
    end
  end

  def DatabaseManager.check_netid(net_id)
    User.find_each() do |user|
      if user[:netid] == net_id
        return true
      end
    end

    return false
  end

  def DatabaseManager.reset_database()
    Course.delete_all

    # TODO: populate courses collection here...
  end
end
