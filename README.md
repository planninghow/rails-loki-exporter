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

 # Usage gem in test env:
to run gem for test(for Macbook): 
 after installing Grafana
 - brew services start grafana (start Grafana) 

    after start grafana open webbrowser http://localhost:3000 and sighIn with login: admin, password: admin.
    setup Grafana > Home > Connections > Data sources > Loki
    setup URL: http://localhost:3100

 - brew services restart grafana-agent-flow             //(restart Grafana)
 - brew services stop grafana-agent-flow                //(stop Grafana)
    
    Ctrl+C (stop Loki)

 # Usage in your application
 - add gem "rails_loki_exporter_dev-0.0.1.gem"                        // to the Gemfile
 - bundle install
 
 In your Rails app project 
- create file 'config/config.yml'

auth_enabled: true
base_url: 'Your grafana loki url'                                    // your url ('https://logs-prod-006.grafana.net')
user_name: 'Your User number'                                        // your User ('747344')
password: 'Your Grafana.com API Token.'                              // your Grafana.com API Token. ('glc_eya2VuLW5ld3...')
log_file_path: "log/#{Rails.env}.log"                                // 
logs_type: '%w(ERROR WARN FATAL INFO DEBUG)'                         // or use logs_type: %w(ERROR WARN FATAL INFO DEBUG)
host_name: 'Your host name'                                          // your host name
job_name: 'Your job name'                                            // your job name
intercept_logs: true
enable_log_subscriber: true                                          // enable or disable LogSubscriber

- in your 'application.rb'

   config.after_initialize do
      config_file_path = File.join(Rails.root, 'config', 'config.yml') // path to your created config.yml
      logger = RubyForGrafanaLoki.create_logger(config_file_path)
      Rails.logger = logger
   end
