module RailsLokiExporterDev
    module Request
    include RailsLokiExporterDev:: Connection
    
        def post(path, params = {})
            connection.post(path, params)
        end
    end 
end 