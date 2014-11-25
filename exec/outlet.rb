#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/outlet'

daemon = Opener::Daemons::Daemon.new(Opener::Outlet)

daemon.start
