# Rails Loki Exporter

:gem: **Rails Loki Exporter** :gem: is a simple log epxporter for Rails.

Export logs for your Rails application to Loki instance and access them through Grafana dashboard. 
## Prerequisites
:exclamation: Before you start make sure you set up the following:
- Grafana Dashboard
- Loki Server


## Installation

**Rails Loki Exporter**'s installation is pretty straightforward.

Using Bundler:
- Add a line for **Rails Loki Exporter** gem in your Rails application `Gemfile`:
```rb
...
gem 'rails_loki_exporter', '~> <version>'
...
```
- Install dependencies using `bundler`:
```sh
$ bundle install
```
- In your Rails application create `config/config.yml` file:
```
auth_enabled: true
base_url: 'Your grafana loki url' 
user_name: 'Your User number'
password: 'Your Grafana.com API Token'
log_file_path: 'log/#{Rails.env}.log'
logs_type: '%w(ERROR WARN FATAL INFO DEBUG)'
interaction_interval: 5
max_buffer_size: 100
intercept_logs: true
``` 
- Add block for **Rails Loki Exporter** in your `application.rb` file:
```
require 'ruby_for_grafana_loki'
   ...
   ...
   ...

   config.after_initialize do
      config_file_path = File.join(Rails.root, 'config', 'config.yml')
      logger = RailsLokiExporters.create_logger(config_file_path)
      Rails.logger = logger
   end
```
- Start your Rails application:
```sh
$ rails s
```

## Deployment

Add additional notes about how to deploy this on a production system.

## Resources

Add links to external resources for this project, such as CI server, bug tracker, etc.