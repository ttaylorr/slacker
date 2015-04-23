require_relative 'plugin'

module Slacker
  module Plugins
    class TimezonePlugin < Plugin
      def ready(robot)
        robot.respond /I live in GMT(\+|-)(\d)/i do |message, matches|
          time_offset = "#{matches[1]}#{matches[2]}"

          set_timezone(message.user, robot, matches[1], matches[2])
          message << "Okay! I'll remember that you live in GMT#{time_offset}."
        end

        robot.respond /what time is it for (\@?(.*))/i do |message, matches|
          target_user = robot.adapter.user_by_name(matches[1])
          time_offset = get_timezone(target_user, robot)

          if time_offset
            local_time = Time.now.getlocal(time_offset)
            formatted_time = local_time.strftime("%H:%M%p")

            time_comment = case local_time.hour
                           when 0..7
                             "It's pretty early! "
                           when 19..23
                             "It's pretty late! "
                           end

            message << "#{time_comment}Looks like it's #{formatted_time} for @#{target_user["name"]}."
          else
            message << "Hmm... I don't know what time it is for @#{matches[1]}"
          end
        end
      end

      def set_timezone(user, robot, sign, hours)
        robot.redis.set(make_timezone_key(user), "#{sign}0#{hours}:00")
      end

      def get_timezone(target, robot)
        robot.redis.get(make_timezone_key(target))
      end

      private
      def make_timezone_key(user)
        "timezone:#{user["id"] || user}"
      end 
    end
  end
end
