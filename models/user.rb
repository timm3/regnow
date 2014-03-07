class User
  include MongoMapper::Document

  key :name,          String
  key :netid,         String
  key :password,      String
  key :join_date,     Date
  key :text_only,     Boolean
  key :email_only,    Boolean
  key :number,        String
  key :crns,          Array
end
