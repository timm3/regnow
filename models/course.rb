class Course
  include MongoMapper::Document

  key :name,          String
  key :crn,           Integer
  key :code,          String
  key :instructor,    String
  key :open_slots,    Integer
  key :total_slots,   Integer
  key :section,       String
  key :subject,       String
  key :type,          String
end
