require 'rspec'
require_relative '../lib/robot'

module Slacker
  module SpecHelper
    RSpec.configure do |rspec|
      rspec.before(:each) do
        @robot = Slacker::Robot.new
      end
    end
  end
end
