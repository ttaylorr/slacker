require_relative '../plugin'
require_relative './graph_view_plugin.rb'

module Slacker
  module Plugins
    class GraphiteEnsemble < Plugin
      def ready(robot)
        robot.plug(GraphViewPlugin.new)
      end
    end
  end
end
