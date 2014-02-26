class User
  include MongoMapper::Document

  key :name,                  String
  key :netid,                 String
  key :password,              String
  key :join_date,             Date
  key :notification_only,     Boolean
end
