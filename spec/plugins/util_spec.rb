require 'timecop'
require 'timerizer'

require_relative '../spec_helper'
require_relative '../../lib/plugins/util_plugin'

include Slacker::SpecHelper

describe Slacker::Plugins::UtilPlugin do
  before(:each) do
    @robot.plug(Slacker::Plugins::UtilPlugin.new)
  end

  it "replies 'pong' to messages matching /ping/" do
    expect(@robot.hear(construct_message("#{bot_name} ping")).response).to include("Pong!")
  end

  it "does not reply to messages not matching /ping/" do
    expect(@robot.hear(construct_message("#{bot_name} pong")).response).not_to include("Pong!")
  end

  it "echos a given message" do
    message = "some message"
    other_message = "some other message"

    expect(@robot.hear(construct_message("#{bot_name} echo #{message}")).response).to include(message)
    expect(@robot.hear(construct_message("#{bot_name} echo #{message}")).response).not_to include(other_message)
  end
end
