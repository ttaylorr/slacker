require 'dotenv'

require_relative '../adapter'
require_relative '../../message'
require_relative 'slack_http_client'

module Slacker
  module Adapters
    class SlackAdapter < Adapter
      def initialize(robot)
        super

        @username, @token, @channel =
          ENV['NAME'], ENV['SLACK_TOKEN'], ENV['SLACK_GROUP']

        @api = SlackHttpClient.new(@token, @username)
      end

      def run
        queue = Queue.new
        workers = Array.new(16) { Thread.new {
          w = QueueWorker.new(queue, self) 
          loop { w.work }
        }}

        last_query_time = Time.now

        # Start querying slack and populate the queue
        populator = Thread.new {
          loop do
            history = @api.group_history(@channel, last_query_time)

            if history.key? "messages"
              history["messages"].select do |message|
                message.key? "user"
              end.each do |message|
                queue.enq(message)
              end
            end

            last_query_time = Time.now
            sleep(5)
          end
        }

        # Attach a bunch of workers to the queue and handle incoming messages
        workers.each(&:join)
        populator.join
      end

      def send(message)
        unless message.response.empty?
          @api.post_message(@channel, message.pretty_response, ENV['SLACK_ICON'])
        end
      end
    end

    class QueueWorker < Struct.new(:queue, :adapter)
      def work
        raw_message = self.queue.pop

        return unless raw_message.key? "user"
        self.adapter.hear(raw_message["text"])
      end
    end
  end
end
