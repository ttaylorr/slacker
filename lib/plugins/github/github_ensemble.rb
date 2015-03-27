require_relative './plugins/github_identity_plugin'

require_relative 'github_identity_manager'
require_relative '../plugin'

module Slacker
  module Plugins
    class GitHubEnsemble < Plugin
      def ready(robot)
        identity_manager = ::GitHubIdentityManager.new(robot)

        robot.plug(GitHubIdentityPlugin.new(identity_manager))
      end
    end
  end
end
