require_relative '../adapter'

module Slacker
  module Adapters
    class ConsoleAdapter < Adapter
      def initialize(robot)
        super
      end

      def run
        loop do
          print ">> "

          hear({
            :text => gets.chomp,
            :channel => { name: 'Console' },
            :user => { name: 'User' }  
          })
        end
      end

      def send(message)
        unless message.response.empty?
          puts "<< [#{@robot.name}] #{message.pretty_response}\n\n"
        end
      end
    end
  end
end
