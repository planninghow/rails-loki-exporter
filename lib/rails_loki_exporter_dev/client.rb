module RailsLokiExporterDev

    class Client
    include RailsLokiExporterDev::Request
        def initialize
        
        end 

        def someClientRequest(someText)
            post "label", {text: someText}
        end

        def getQuery(path) #"query", "query_range", "labels" and etc
            get "loki/api/v1/#{path}"
        end
    end     
end 