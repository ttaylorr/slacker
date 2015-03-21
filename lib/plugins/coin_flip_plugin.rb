require_relative 'plugin'

module Slacker
  module Plugins
    class CoinFlipPlugin < Plugin
      def ready(robot)
        robot.respond /(throw|flip|toss) a coin/i do |message|
          message << "I get... #{random_side}!"
        end
      end

      def random_side
        ["heads", "tails"].sample
      end
    end
  end
end
