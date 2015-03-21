require_relative 'plugin'

require 'dotenv'
require 'jiralicious'

module Slacker
  module Plugins
    class JiraPlugin < Plugin
      def initialize
        Jiralicious.configure do |config|
          config.username = ENV["JIRA_USERNAME"]
          config.password = ENV["JIRA_PASSWORD"]
          config.uri = ENV["JIRA_URL"]
          config.api_version = "latest"
          config.auth_type = :basic
        end

        @jira = Jiralicious
      end

      def ready(robot)
        robot.respond /i am (.*) on jira/i do |message, match|
          username = match.captures[0]
          handle_username_change(username, message, robot)
        end

        robot.respond /(?:show me)?(?:my issues\s?)(?:on JIRA\s)?(?:(?:on|in|affecting)\s(.*))?/i do |message, match|
          jira_opts = {
            :username => get_jira_username(robot, message.user),
            :project => match[1] || ENV["JIRA_DEFAULT_PROJECT"]
          }

          if jira_opts[:username].nil?
            message << "What's your JIRA username, again?"

            message.expect_reply /.*/ do |reply, match|
              handle_username_change(match, reply, robot)

              jira_opts[:username] = match

              write_jira_issues_to(reply, jira_opts, robot)
            end
          else
            write_jira_issues_to(message, jira_opts, robot)
          end
        end
      end

      def handle_username_change(username, message, robot)
        begin
          jira_user = @jira::User.find(username)
          set_jira_username(robot, message.user, jira_user.name)

          message << "OK, you are *#{jira_user.name}* on JIRA"
        rescue Exception => e
          message << "I couldn't find a user named #{username} on JIRA :disappointed:"
        end
      end

      def write_jira_issues_to(message, opts, robot)
        issues_query = "PROJECT=\"#{opts[:project]}\" AND assignee in (#{opts[:username]}) AND status=Open"
        response = @jira.search(issues_query)

        robot.send_message("Okay, looking for JIRA issues assigned to you on #{opts[:project]}...", message.channel)

        message << "I found #{response.issues.length} issues assigned to you on #{opts[:project]}:"
        response.issues.each do |issue|
          issue_url = "#{ENV["JIRA_URL"]}/browse/#{issue.jira_key}"
          message << "*#{issue.jira_key}* - #{issue.summary} (#{issue_url})"
        end
      end

      private
      def set_jira_username(robot, user, username)
        robot.redis.set(make_jira_key(user), username)
      end

      def get_jira_username(robot, user)
        robot.redis.get(make_jira_key(user))
      end

      def make_jira_key(user)
        "jira:#{user["id"]}:username"
      end
    end
  end
end
