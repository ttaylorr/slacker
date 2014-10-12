require_relative 'plugin'

module Slacker
  module Plugins
    class PingPlugin
      def ready(robot)
        robot.respond /ping/ do |message|
          message.write("Pong!")
        end
      end
    end
  end
end
