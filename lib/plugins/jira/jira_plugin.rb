require_relative '../plugin'

module Slacker
  module Plugins
    class JiraPlugin < Plugin
      def ready(robot)
        robot.respond /i am (.*) on jira/i do |message, match|
          username = match.captures[0]

          set_jira_username(robot, message.user, username)
          message << "OK, you are *#{username}* on JIRA"
        end

        robot.respond /my\sissues/ do |message|
          jira_name = get_jira_username(robot, message.user)

          if jira_name.nil?
            message << "What's your JIRA username, again?"
            message.expect_reply /.*/ do |reply, match|
              jira_name = match

              set_jira_username(robot, message.user, jira_name)
              write_jira_issues_to(reply, jira_name)
            end
          else
            write_jira_issues_to(message, jira_name)
          end
        end
      end

      def write_jira_issues_to(message, jira_username)
        message << "Gathering issues for #{jira_username}"
      end

      private
      def set_jira_username(robot, user, username)
        robot.redis.set(make_jira_key(user), username)
      end

      def get_jira_username(robot, user)
        robot.redis.get(make_jira_key(user))
      end

      def make_jira_key(user)
        "jira:username:#{user["id"]}"
      end
    end
  end
end
