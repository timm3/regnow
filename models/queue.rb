class Queue
  include MongoMapper::Document
  set_collection_name "queue"

  key :crn,           Integer
  key :netids,        Array
  key :last_updated,  Time
end
