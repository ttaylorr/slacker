require 'dotenv'
require 'rspec'

require_relative '../lib/robot'

Dotenv.load

module Slacker
  module SpecHelper
    RSpec.configure do |rspec|
      rspec.before(:each) do
        @robot = Slacker::Robot.new(bot_name)
      end
    end

    # Public - returns the name of the robot as
    # specified by the .env configuration file
    # (or "slacker" if none is given)
    #
    # Returns the name
    def bot_name
      ENV["NAME"] || "slacker"
    end

    def construct_message(message, channel=nil, user=nil)
      {
        :text => message,
        :channel => channel,
        :user => user
      }
    end
  end
end
