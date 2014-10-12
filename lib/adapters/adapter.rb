module Slacker
  module Adapters
    class Adapter
      attr_reader :robot

      # Public - iniitalizes an adapter
      #
      # robot - the robot to relay messages to
      def initialize(robot)
        @robot = robot
      end

      # Public - sends a message back to the chat room
      #
      # Note: subclasses should implement this method 
      #
      # message - the MessageData object to send back
      #
      # Returns a boolean indicating the success of sending
      # the message back to the server
      def send(message)
      end

      # Public - proxy method to send a message back
      # to the robot
      #
      # message - the message that was heard
      #
      # Returns nothing 
      def recieve(message)
        @robot.hear(message)
      end

      # Public - method that is called after the adapter
      # is initialized
      #
      # Note: subclasses should implement this method
      #
      # Returns nothing
      def run
      end
    end
  end
end
