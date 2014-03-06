class Course
  include MongoMapper::Document
  
  key :title,         String
  key :credit_hours   Array
  key :term           String
  key :subject        String
  key :year	          String
  key :crns           Array
  key :description    String
  key :code           String
  key :course_id      String
  #key :total_slots    Integer
  #key :open_slots     Integer
end
