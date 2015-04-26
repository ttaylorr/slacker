require 'terminal-table'

require_relative 'plugin'

module Slacker
  module Plugins
    class RememberPlugin < Plugin
      def ready(robot)
        robot.respond /remember (.*) is (.*)/i do |message, match|
          key, value = match[1], match[2]
          remember(key, value, robot)

          message << "Okay, I'll remember that #{key} is #{value}."
        end

        robot.respond /what is (.*)/i do |message, match|
          key = match[1]
          value = recall(key, robot)

          message << (value ? value : "I don't remember what #{key} is...")
        end

        robot.respond /forget (.*)/i do |message, match|
          key = match[1]
          forget(key, robot)

          message << "I suddenly forgot what #{key} is!"
        end

        robot.respond /what do you (?:remember|know)/i do |message|
          memories = robot.redis.keys(make_key('*'))
          if memories.empty?
            message << "I don't know anything!"
          else
            rows = memories.each_with_index.map do |key, i|
              name = key.match(/memory:(.*)/i)[1]
              [i + 1, name, recall(name, robot)]
            end

            message << "Here are some things that I remember:"
            table = Terminal::Table.new(:headings => ['#', 'Name', 'Memory'],
                                        :rows => rows)

            message << "```#{table.to_s}```"
          end
        end
      end

      def remember(key, value, robot)
        robot.redis.set(make_key(key), value)
      end

      def forget(key, robot)
        robot.redis.del(make_key(key))
      end

      def recall(key, robot)
        robot.redis.get(make_key(key))
      end

      private
      def make_key(key)
        "memory:#{key}".downcase
      end
    end
  end
end
