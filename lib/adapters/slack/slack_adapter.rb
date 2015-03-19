require 'dotenv'
require 'websocket-eventmachine-client'
require 'json'

require_relative '../adapter'
require_relative '../../message'
require_relative 'slack_http_client'

module Slacker
  module Adapters
    class SlackAdapter < Adapter
      attr_reader :channels, :users, :username

      def initialize(robot)
        super
        @name, @token =
          ENV['NAME'], ENV['SLACK_TOKEN']

        @api = SlackHttpClient.new(@name, @token)
      end

      def run
        @rtm_meta = @api.start_rtm

        @channels = (@rtm_meta["channels"] + @rtm_meta["groups"] + @rtm_meta["ims"])
        @users = (@rtm_meta["users"] + @rtm_meta["bots"])

        queue = Queue.new
        workers = create_worker_pool(queue, 16)

        start_websocket(queue)

        # Attach a bunch of workers to the queue and handle incoming messages
        workers.each(&:join)
      end

      def send(message)
        super
        @socket.send({
          :type => 'message',
          :channel => message.channel["id"],
          :text => message.pretty_response
        }.to_json)
      end

      def channel_by_id(channel_id)
        @channels.select { |channel| channel["id"] == channel_id }.first
      end

      def user_by_id(user_id)
        @users.select { |user| user["id"] == user_id }.first
      end

      private
      def create_worker_pool(queue, size=16)
        Array.new(16) do
          Thread.new do
            w = QueueWorker.new(queue, self) 
            loop { w.work }
          end
        end
      end

      def start_websocket(queue)
        EM.run do
          @socket = WebSocket::EventMachine::Client.connect(:uri => @rtm_meta["url"])

          @socket.onmessage do |msg, type|
            packet = JSON.parse(msg)
            if packet["type"] == "message" && packet["text"]
              # Replace Slack's username @ mention with their actual username
              packet["text"].gsub! /<@U(.{8})>/ do |match|
                matched_user = user_by_id("U#{$1}")
                matched_user["name"] if matched_user
              end

              queue << packet
            end
          end
        end
      end
    end

    class QueueWorker < Struct.new(:queue, :adapter)
      def work
        message = self.queue.pop

        self.adapter.hear({
          :text => message["text"],
          :channel => self.adapter.channel_by_id(message["channel"]),
          :user => self.adapter.user_by_id(message["user"])
        })
      end
    end
  end
end
