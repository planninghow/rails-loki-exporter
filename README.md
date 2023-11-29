# fpio/rails-loki-exporter-dev



## Getting Started

Download links:

SSH clone URL: ssh://git@git.jetbrains.space/shikolay/fpio/rails-loki-exporter-dev.git

HTTPS clone URL: https://git.jetbrains.space/shikolay/fpio/rails-loki-exporter-dev.git



These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

What things you need to install the software and how to install them.

```
Examples
```

## Deployment

Add additional notes about how to deploy this on a production system.

## Resources

Add links to external resources for this project, such as CI server, bug tracker, etc.

You need to setup Loki for your env: follow this videl: https://www.youtube.com/watch?v=0B-yQdSXFJE

to run gem for test(for Macbook): 
 - gem uninstall build rails_loki_exporter_dev (if you install gem before)
 - gem build rails_loki_exporter_dev.gemspec
 - gem install rails_loki_exporter_dev-0.0.1.gem
 - irb (launch ruby's interactive console)

 - require 'rails_loki_exporter_dev'
 - client = RailsLokiExporterDev.client (create client)
 - result = client.send_log : "some log tennet" (send log)