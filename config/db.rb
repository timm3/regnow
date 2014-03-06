@config = YAML.load_file(File.dirname(__FILE__) + "/config.yaml")

$environment = @config["environment"]
$netid = @config["netid"]
$password = @config ["password"]

@db_host = @config[$environment]["host"]
@db_port = @config[$environment]["port"]
@db_name = @config[$environment]["database"]

MongoMapper.connection = Mongo::Connection.new(@db_host, @db_port)
MongoMapper.database = @db_name

MongoMapper.connection.connect
