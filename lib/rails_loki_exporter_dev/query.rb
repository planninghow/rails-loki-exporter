module RailsLokiExporterDev
    class Query
        attr_reader :resultType, :result, :stats
        def initialize(response) 
            @resultType = response['resultType']
            @result = response['result']
            @stats = response['stats']
        end
    end     
end 

# {
#   "status": "success",
#   "data": {
#     "resultType": "vector" | "streams",
#     "result": [<vector value>] | [<stream value>],
#     "stats" : [<statistics>]
#   }
# }