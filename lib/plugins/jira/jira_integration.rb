require_relative '../plugin'
require_relative './jira_datastore'

# Require all of the plugins associated with JIRA
require_relative './plugins/browse_issues_plugin.rb'
require_relative './plugins/issue_assignment_plugin.rb'
require_relative './plugins/issue_info_plugin.rb'
require_relative './plugins/state_change_plugin.rb'

module Slacker
  module Plugins
    class JiraIntegration < Plugin
      def ready(robot)
        configure_jiralicious
        datastore = ::Slacker::JiraDatastore.new(robot)

        # Plug them all in!
        robot.plug(BrowseIssuesPlugin.new(datastore))
        robot.plug(IssueAssignementPlugin.new(datastore))
        robot.plug(IssueInfoPlugin.new(datastore))
        robot.plug(StateChangePlugin.new)
      end

      def configure_jiralicious
        Jiralicious.configure do |config|
          config.username = ENV["JIRA_USERNAME"]
          config.password = ENV["JIRA_PASSWORD"]
          config.uri = ENV["JIRA_URL"]
          config.api_version = "latest"
          config.auth_type = :basic
        end
      end
    end
  end
end
