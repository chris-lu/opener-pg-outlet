#!/usr/bin/env ruby

require 'opener/daemons'
require_relative '../lib/opener/outlet'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon  = Opener::Daemons::Daemon.new(Opener::Outlet, options)

daemon.start