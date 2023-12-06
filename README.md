# fpio/rails-loki-exporter-dev



## Getting Started

Download links:

SSH clone URL: ssh://git@git.jetbrains.space/shikolay/fpio/rails-loki-exporter-dev.git

HTTPS clone URL: https://git.jetbrains.space/shikolay/fpio/rails-loki-exporter-dev.git



These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

What things you need to install the software and how to install them.

```
You need to setup Grafana, Loki Grafana for your env: 
follow this video: https://www.youtube.com/watch?v=0B-yQdSXFJE
about Grafana https://grafana.com/docs/agent/latest/flow/setup/start-agent/
- brew install grafana (install Grafana) 
```

## Deployment

Add additional notes about how to deploy this on a production system.

## Resources

Add links to external resources for this project, such as CI server, bug tracker, etc.


to run gem for test(for Macbook): 
 after installing Grafana
 - brew services start grafana (start Grafana) 

    after start grafana open webbrowser http://localhost:3000 and sighIn with login: admin, password: admin.
    setup Grafana > Home > Connections > Data sources > Loki
    setup URL: http://localhost:3100

 - brew services restart grafana-agent-flow             //(restart Grafana)
 - brew services stop grafana-agent-flow                //(stop Grafana)
    
    Ctrl+C (stop Loki)


test gem with irb:
go to your project folder:
 - gem uninstall build rails_loki_exporter_dev           //(if you install gem before)
 - gem build rails_loki_exporter_dev.gemspec
 - gem install rails_loki_exporter_dev-0.0.1.gem
 - irb (launch ruby's interactive console)

 - log_file_path = "log/#{Rails.env}.log"                 //(your path to .log)
 - client = RailsLokiExporterDev.client(log_folder_name)  //(create client)
 - result = client.send_all._logs                         //(send all logs)



 # Usage in your application

 - log_file_path = "log/#{Rails.env}.log"
 - client = RubyForGrafanaLoki.client(log_file_path)
 - client.send_all_logs
 - client.send_log("This is a test log message.")
