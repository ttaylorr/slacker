require_relative '../../plugin'

require 'dotenv'
require 'jiralicious'
require 'terminal-table'
require 'active_support/all'

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
        robot.send_message("Okay, looking for JIRA issues assigned to you on #{opts[:project]}...", message.channel)

        issues_query = "PROJECT=\"#{opts[:project]}\" AND assignee in (#{opts[:username]}) AND status=Open"
        response = @jira.search(issues_query)

        message << "I found #{response.issues.length} issues assigned to you on #{opts[:project]}:"

        rows = response.issues.map do |issue|
          [issue.jira_key,
           issue.summary.truncate(69),
           "#{ENV["JIRA_URL"]}/browse/#{issue.jira_key}"]
        end

        headers = ['ID', 'Summary', 'URL']
        table = Terminal::Table.new(:headings => headers, :rows => rows)

        message << "```#{table}```"
      end
    end
  end
end
