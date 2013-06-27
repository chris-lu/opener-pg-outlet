require File.expand_path('../lib/opener/outlet', __FILE__)
require 'active_record'

db = SQLite3::Database.new('db/production.db')
db.execute("create table outputs (uuid varchar(40), text text);") rescue nil

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'db/production.db'
)

run Opener::Outlet
