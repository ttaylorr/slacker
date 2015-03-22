require_relative '../../plugin'

require 'dotenv'
require 'jiralicious'

module Slacker
  module Plugins
    class BrowseIssuesPlugin < Plugin
      def initialize(username_datastore)
        @jira = Jiralicious
        @usernames = username_datastore
      end

      def ready(robot)
        robot.respond /i am (.*) on jira/i do |message, match|
          username = match.captures[0]
          @usernames.handle_username_change(username, message)
        end

        robot.respond /(?:show me)?(?:my issues\s?)(?:on JIRA\s)?(?:(?:on|in|affecting)\s(.*))?/i do |message, match|
          jira_opts = {
            :username => @usernames.get_jira_username(message.user),
            :project => match[1] || ENV["JIRA_DEFAULT_PROJECT"]
          }

          if jira_opts[:username].nil?
            message << "What's your JIRA username, again?"

            message.expect_reply /.*/ do |reply, match|
              @usernames.handle_username_change(match, reply)

              jira_opts[:username] = match

              write_jira_issues_to(reply, jira_opts, robot)
            end
          else
            write_jira_issues_to(message, jira_opts, robot)
          end
        end
      end

      private
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
    end
  end
end
