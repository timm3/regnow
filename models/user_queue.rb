class UserQueue
  include MongoMapper::Document
  set_collection_name "queue"

  key :crn,           Array
  #key :last_updated,  Time
  #key :user_ids,      Array
  #many :users, :in => :user_ids
  key :netids,        Array
end
