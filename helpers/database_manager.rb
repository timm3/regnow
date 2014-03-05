module DatabaseManager

  def DatabaseManager.add_course(name, crn, code, instructor)
    course = Course.create(:name => name, :crn => crn, :code => code, :instructor => instructor)
    course.save
  end

  def DatabaseManager.reset_database()
    Course.delete_all
    
    # TODO: populate courses collection here...
  end
end
