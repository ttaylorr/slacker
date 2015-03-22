require_relative '../../plugin'

require 'jiralicious'
require 'terminal-table'

module Slacker
  module Plugins
    class IssueInfoPlugin < Plugin
      def initialize(user_datastore)
        @jira = Jiralicious
        @users = user_datastore
      end

      def ready(robot)
        robot.respond /(?:info me|(?:show info|tell me) about|what is)\s?(\w{3,4}-\d*)/i do |message, match|
          issue_key = match[1].upcase
          begin
            robot.send_message("Looking for info about #{issue_key}...", message.channel)

            issue = @jira::Issue.find(issue_key)

            assigner = @users.get_slack_username(issue['fields']['creator']['name']) || issue['fields']['creator']['name']
            assignee = @users.get_slack_username(issue['fields']['assignee']['name']) || issue['fields']['assignee']['name']

            status = issue['fields']['status']['name'].downcase
            issue_url = "#{ENV["JIRA_URL"]}/browse/#{issue_key}"

            rows = []
            rows << [issue_key, "@#{assigner}", "@#{assignee}", issue.summary, status]
            table = Terminal::Table.new(:headings => ['ID', 'Assigner', 'Assignee', 'Description', 'Status'], :rows => rows)

            message << "```#{table}```"
          rescue Jiralicious::IssueNotFound => e
            message << "I don't know anything about #{issue_key}."
          end
        end
      end
    end
  end
end
