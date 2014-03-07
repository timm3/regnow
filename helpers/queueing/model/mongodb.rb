require "mongo"
require './model/user'

include Mongo

CONNECTION = Mongo::Connection.new("localhost")
DB	   = CONNECTION.db('courses')

#Some aliases for collections in the database
DATA	= DB['courses_general']
