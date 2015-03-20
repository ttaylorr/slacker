require_relative 'plugin'

module Slacker
  module Plugins
    class ConversationPlugin
      def ready(robot)
        robot.respond /conv\stest/ do |message|
          message << 'What is your name, again?'

          message.expect_reply /([\w]*)/ do |reply, match|
            reply << "Right!  Your name is #{match}"
          end
        end
      end
    end
  end
end
