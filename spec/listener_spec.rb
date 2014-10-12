require_relative 'spec_helper'
require_relative '../lib/listener'

include Slacker::SpecHelper

describe Slacker::Robot do
  let(:responder_block) { Proc.new { |message| }}

  it "responds to matching messages" do
    @robot.respond(/^message$/, &responder_block)

    expect(responder_block).to receive(:call)
    @robot.hear("message")
  end

  it "doesn't respond to messages that don't match" do
    @robot.respond(/slacker/, &responder_block)

    expect(responder_block).not_to receive(:call)
    @robot.hear("hubot")
  end
end
