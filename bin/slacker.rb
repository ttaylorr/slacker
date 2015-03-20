#!/usr/bin/ruby

# Load all environment variables from @bkeeper's "dotenv"
require 'dotenv'
Dotenv.load

require_relative '../lib/robot'
require_relative '../lib/adapters/slack/slack_adapter'
require_relative '../lib/plugins/util_plugin'

["         __           __               ",
 "   _____/ /___ ______/ /_____  _____   ",
 "  / ___/ / __ `/ ___/ //_/ _ \\/ ___/  ",
 " (__  ) / /_/ / /__/ ,< /  __/ /       ",
 "/____/_/\\__,_/\\___/_/|_|\\___/_/     ",
 "",                                      ].each do |segment|
  puts segment.green
end

r = Slacker::Robot.new

# Attach all the plugins
r.plug(Slacker::Plugins::UtilPlugin.new)

# Plug in the adapter and run
r.attach(Slacker::Adapters::SlackAdapter.new(r))
