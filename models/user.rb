class User
  include MongoMapper::Document

  key :name,          String
  key :netid,         String
  key :password,      String
  key :adPassword,    String
  key :regnow,        Boolean
  key :salt,          String
  key :adSalt,        String
#  key :text_only,     Boolean
#  key :email_only,    Boolean
#  key :number,        String
#  key :crns,          Array
end
