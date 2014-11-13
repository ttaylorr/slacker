#!/usr/bin/ruby

require 'dotenv'
Dotenv.load

require_relative '../lib/robot'
require_relative '../lib/adapters/repl/console_adapter'
require_relative '../lib/plugins/util_plugin'

r = Slacker::Robot.new(ENV["NAME"])

# Attach all the plugins
r.plug(Slacker::Plugins::UtilPlugin.new)

# Plug in the adapter and run
r.attach(Slacker::Adapters::ConsoleAdapter.new(r))
