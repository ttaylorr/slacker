#!/usr/bin/ruby

require 'dotenv'
Dotenv.load

require_relative '../lib/robot'
require_relative '../lib/adapters/repl/console_adapter'
require_relative '../lib/plugins/util_plugin'
require_relative '../lib/plugins/jira_plugin'
require_relative '../lib/plugins/coin_flip_plugin'

r = Slacker::Robot.new(ENV["NAME"])

# Attach all the plugins
r.plug(Slacker::Plugins::UtilPlugin.new)
r.plug(Slacker::Plugins::JiraPlugin.new)
r.plug(Slacker::Plugins::CoinFlipPlugin.new)

# Plug in the adapter and run
r.attach(Slacker::Adapters::ConsoleAdapter.new(r))
