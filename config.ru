require File.expand_path('../lib/opener/outlet', __FILE__)
require File.expand_path('../lib/opener/outlet/server', __FILE__)
require 'sqlite3'
require 'active_record'
require File.expand_path('../config/database', __FILE__)

run Opener::Outlet::Server
