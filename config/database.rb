require 'active_record'
require 'activerecord-jdbcpostgresql-adapter'

db_pass = ENV["DB_PASS"]
db_name = ENV["DB_NAME"]
db_user = ENV["DB_USER"]
db_host = ENV["DB_HOST"]
db_port = ENV["DB_PORT"]

ActiveRecord::Base.establish_connection(
    adapter:  'postgresql',
    database: db_name,
    host:     db_host,
    username: db_user,
    password: db_pass,
    port: db_port || '5432'
)

ActiveRecord::Base.connection.execute("CREATE TABLE IF NOT EXISTS outputs (uuid varchar(40), text text, created_at timestamp DEFAULT CURRENT_TIMESTAMP);")
ActiveRecord::Base.connection.execute("CREATE INDEX IF NOT EXISTS uuid_index ON outputs(uuid);")
