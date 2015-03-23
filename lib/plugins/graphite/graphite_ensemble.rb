require_relative '../plugin'

require_relative './graphite_api.rb'

require_relative './graph_view_plugin.rb'
require_relative './graph_search_plugin.rb'

module Slacker
  module Plugins
    class GraphiteEnsemble < Plugin
      def ready(robot)
        graphite_api = GraphiteAPI.new(ENV["GRAPHITE_API_HOST"], ENV["GRAPHITE_API_PORT"])

        robot.plug(GraphViewPlugin.new)
        robot.plug(GraphSearchPlugin.new(graphite_api))
      end
    end
  end
end
