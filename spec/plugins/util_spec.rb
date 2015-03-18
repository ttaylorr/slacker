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

  it "replies to the current time" do
    now_time = Time.now

    Timecop.freeze(now_time) do
      expect(@robot.hear(construct_message("#{bot_name} time")).response).to include(now_time)
    end

    Timecop.freeze(3.days.from_now) do
      expect(@robot.hear(construct_message("#{bot_name} time")).response).not_to include(now_time)
    end
  end

  it "echos a given message" do
    message = "some message"
    other_message = "some other message"

    expect(@robot.hear(construct_message("#{bot_name} echo #{message}")).response).to include(message)
    expect(@robot.hear(construct_message("#{bot_name} echo #{message}")).response).not_to include(other_message)
  end
end
