require File.expand_path('../lib/opener/outlet', __FILE__)
require File.expand_path('../lib/opener/outlet/server', __FILE__)

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run Opener::Outlet::Server
