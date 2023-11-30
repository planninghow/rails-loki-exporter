module RailsLokiExporterDev
    class Client
    include RailsLokiExporterDev::Request

        def send_log(log_message)
          curr_datetime = Time.now.to_i * 1_000_000_000
          labels = "{source=\"my_gem\",job=\"my_gem_job\"}"
    
          payload = {
            "streams" => [
             {
               "stream" => { "foo" => "bar2" },
               "values" => [
                ["#{curr_datetime}", log_message]
                ]
              }
            ]
          }

          json_payload = JSON.generate(payload)
          uri = '/loki/api/v1/push'
          post uri, json_payload
        end
       
    end     
end 