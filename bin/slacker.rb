#!/usr/bin/ruby

# Load all environment variables from @bkeeper's "dotenv"
require 'dotenv'
Dotenv.load

require_relative '../lib/robot'
require_relative '../lib/adapters/slack/slack_adapter'
require_relative '../lib/plugins/util_plugin'

r = Slacker::Robot.new

# Attach all the plugins
r.plug(Slacker::Plugins::UtilPlugin.new)

# Plug in the adapter and run
r.attach(Slacker::Adapters::SlackAdapter.new(r))
