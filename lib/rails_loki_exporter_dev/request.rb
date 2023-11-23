module RailsLokiExporterDev
    module Request
    include RailsLokiExporterDev:: Connection
    
        def post(path, params = {})
            connection.post(path, params)
        end

        def get(path)
            respond_with(
                connection.get(path)
            )
        end

        private 
        def respond_with(response)
            body = response.body.empty? ? response.body : JSON.parse(response.body)
        end
    end 
end 