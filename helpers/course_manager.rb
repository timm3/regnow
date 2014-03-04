require 'mechanize'

module CourseManager
  def CourseManager.add_course(name, crn, code, instructor)
    course = Course.create(:name => name, :crn => crn, :code => code, :instructor => instructor)
    course.save
  end

  def CourseManager.get_spots(crn)

  end

  def CourseManager.reset()
    Course.delete_all
    
    # TODO: populate courses collection here...
  end
end
