require_relative '../../plugin'

require 'dotenv'
require 'jiralicious'

module Slacker
  module Plugins
    class IssueAssignementPlugin < Plugin
      def initialize(username_datastore)
        @jira = Jiralicious
        @usernames = username_datastore
      end

      def ready(robot)
        robot.respond /assign (\w{3,4}-\d*) to @?([0-9a-zA-Z-_^\w]*)/i do |message, match|
          issue_key = match.captures[0]
          assignee = resolve_assignee(match.captures[1], message, robot)

          if assignee.nil?
            message << "Uh-oh! I can't find @#{match.captures[1]} in Slack anywhere :disappointed:"
          else
            jira_assignee = @usernames.get_jira_username(assignee)
            if jira_assignee.nil?
              message << "Oh-noes! I don't know who @#{assignee} is on JIRA :disappointed:"
            else
              begin
                issue = @jira::Issue.find(issue_key)
                issue.set_assignee(jira_assignee)

                assigned_to = assignee["id"] == message.user["id"] ? "<@#{assignee["name"]}>" : "you."
                issue_url = "#{ENV["JIRA_URL"]}/browse/#{issue_key}"

                message << "Boom! I assigned #{issue_key} to #{assigned_to} (#{issue_url})"
              rescue Jiralicious::IssueNotFound => e
                message << "Hmm... I couldn't find an issue tagged #{issue_key} on JIRA."
              end
            end
          end
        end
      end

      private
      def resolve_assignee(capture, message, robot)
        username = capture.downcase === 'me' ? message.user["name"] : capture
        robot.adapter.user_by_name(username)
      end
    end
  end
end
