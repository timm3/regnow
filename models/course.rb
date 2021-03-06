class Course
  include MongoMapper::Document
  set_collection_name "courses_general"

  key :title,          String
  key :credit_hours,   Array
  key :term,           String
  key :subject,        String
  key :year,           String
  key :crns,           Array
  key :description,    String
  key :code,           String
  key :course_id,      String
end
