require_relative '../spec_helper'
require_relative '../../lib/plugins/ping_plugin'

include Slacker::SpecHelper

describe Slacker::Plugins::PingPlugin do
  before(:each) do
    @robot.plug(Slacker::Plugins::PingPlugin.new)
  end

  it "replies 'pong' to messages matching /ping/" do
    expect(@robot.hear("ping").response).to include("Pong!")
  end

  it "does not reply to messages not matching /ping/" do
    expect(@robot.hear("pong").response).not_to include("Pong!")
  end
end
