#!/usr/bin/ruby

# Load all environment variables from @bkeeper's "dotenv"
require 'dotenv'
Dotenv.load

require_relative '../lib/robot'
require_relative '../lib/adapters/slack/slack_adapter'
require_relative '../lib/plugins/util_plugin'
require_relative '../lib/plugins/conversation_plugin'

["         __           __               ",
 "   _____/ /___ ______/ /_____  _____   ",
 "  / ___/ / __ `/ ___/ //_/ _ \\/ ___/  ",
 " (__  ) / /_/ / /__/ ,< /  __/ /       ",
 "/____/_/\\__,_/\\___/_/|_|\\___/_/     ",
 "",                                      ].each do |segment|
  puts segment.green
end

r = Slacker::Robot.new(ENV["NAME"])

# Attach all the plugins
r.plug(Slacker::Plugins::UtilPlugin.new)
r.plug(Slacker::Plugins::ConversationPlugin.new)

# Plug in the adapter and run
r.attach(Slacker::Adapters::SlackAdapter.new(r))
