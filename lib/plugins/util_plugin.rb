require_relative 'plugin'

module Slacker
  module Plugins
    class UtilPlugin
      def ready(robot)
        robot.respond /ping/ do |message|
          message.write("Pong!")
        end

        robot.respond /time/ do |message|
          message.write(Time.now)
        end

        robot.respond /echo (.*)$/ do |message, match|
          message.write(match[1])
        end
      end
    end
  end
end
