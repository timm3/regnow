class Course
  include MongoMapper::Document

  key :name,        String
  key :crn,      	Integer
  key :code,		String
  key :instructor,	String
end