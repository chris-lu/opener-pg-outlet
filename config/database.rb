require 'active_record'
require 'activerecord-jdbcmysql-adapter'

db_pass = ENV["DB_PASS"]
db_name = ENV["DB_NAME"]
db_user = ENV["DB_USER"]
db_host = ENV["DB_HOST"]

if ENV["RACK_ENV"] == 'production'
  ActiveRecord::Base.establish_connection(
    adapter:  'mysql2',
    database: db_name,
    host:     db_host,
    username: db_user,
    password: db_pass
  )
else
  ActiveRecord::Base.establish_connection(
    adapter:  'mysql2',
    host:     db_host || 'localhost',
    username: 'root',
    password: db_pass || '',
    database: db_name || 'opener_development'
  )
end

ActiveRecord::Base.connection.execute("CREATE TABLE IF NOT EXISTS outputs (uuid varchar(40), text text, created_at timestamp DEFAULT CURRENT_TIMESTAMP);")

if ActiveRecord::Base.connection.execute("SHOW INDEX FROM outputs").nil?
  ActiveRecord::Base.connection.execute("CREATE INDEX uuid_index ON outputs(uuid);")
end
