require 'dotenv'

module Slacker
  class GraphSearchPlugin
    def initialize(graphite_api)
      @graphite_api = graphite_api
    end

    def ready(robot)
      robot.respond /(?:(?:(?:show me|query)\s)?graphs matching|(?:graph\s)?search me) (.*)/i do |message, match|
        query = match[1]
        matching_graphs = @graphite_api.expand(query)

        if matching_graphs.empty?
          message << "I couldn't find any graphs matching `#{query}`"
        else
          message << "I found #{matching_graphs.length} graphs matching the query `#{query}`"
          rows = matching_graphs.each_with_index.map do |id, i|
            [(i+1), id]
          end

          table = Terminal::Table.new(:headings => ["#", "Graph ID"], :rows => rows)
          message << "```#{table}```"
        end
      end
    end
  end
end
