require_relative '../lib/robot'
require_relative '../lib/adapters/slack/slack_adapter'
require_relative '../lib/plugins/ping_plugin'

r = Slacker::Robot.new

r.plug(Slacker::Plugins::PingPlugin.new)
r.attach(Slacker::Adapters::SlackAdapter.new(r))
