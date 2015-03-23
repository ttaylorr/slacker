require_relative '../../plugin'

require 'dotenv'
require 'jiralicious'
require 'terminal-table'

module Slacker
  module Plugins
    class StateChangePlugin < Plugin
      def initialize
        @jira = Jiralicious
        @transition_ids = {
          :reopen => ENV["JIRA_TRANSITION_REOPEN"].to_i,
          :resolve => ENV["JIRA_TRANSITION_RESOLVE"].to_i
        }
      end

      def ready(robot)
        robot.respond /(?:mark (\w{3,4}-\d*) as (?:completed|done|resolved))|(?:(?:close|resolve) (\w{3,4}-\d*))/i do |message, match|
          issue_id = (match[1] || match[2]).upcase

          if preform_transition(issue_id, :resolve, message).nil?
            message << "Cool, I marked #{issue_id} as resolved for you :sunglasses:"
          end
        end

        robot.respond /(?:(?:open|reopen) (\w{3,4}-\d*))|(?:mark (\w{3,4}-\d*) as open(?:ed)?)/i do |message, match|
          issue_id = (match[1] || match[2]).upcase

          if preform_transition(issue_id, :reopen, message).nil?
            message << "Alrighty, I re-opened #{issue_id} for you. Get to work!"
          end
        end
      end

      def preform_transition(issue_id, state, message)
        begin
          transition = @jira::Issue::Transitions.go(issue_id, @transition_ids[state])
        rescue Jiralicious::TransitionError => e
          message << "Uh-oh! JIRA isn't letting me preform that transition for you right now."
        rescue Jiralicious::IssueNotFound => e
          message << "Hm, I can't find anything about #{issue_id.upcase} on JIRA."
        end
      end
    end
  end
end
