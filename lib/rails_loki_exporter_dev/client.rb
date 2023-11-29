module RailsLokiExporterDev
    class Client
    include RailsLokiExporterDev::Request

        def send_log(log_message)
          curr_datetime = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          labels = "{source=\"my_gem\",job=\"my_gem_job\"}"
    
          entry = {
            'ts' => curr_datetime,
            'line' => log_message
          }
    
          payload = {
            'streams' => [
              {
                'labels' => labels,
                'entries' => [entry]
              }
            ]
          }
    
          json_payload = JSON.generate(payload)
          uri = '/loki/api/v1/push'
          post uri, json_payload
        end
       
    end     
end 