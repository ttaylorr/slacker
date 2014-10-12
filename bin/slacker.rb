require_relative '../lib/robot'
require_relative '../lib/adapters/slack/slack_adapter'
require_relative '../lib/plugins/ping_plugin'

module Slacker
  class Slacker
    r = Robot.new

    r.plug(Plugins::PingPlugin.new)
    r.attach(SlackAdapter.new(r))
  end
end
