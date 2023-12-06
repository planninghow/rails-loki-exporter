#!/bin/bash

echo "---- run command: uninstall build rails_loki_exporter_dev ----"
gem uninstall build rails_loki_exporter_dev
echo " "
echo "---- run command: build rails_loki_exporter_dev.gemspec ----"
gem build rails_loki_exporter_dev.gemspec
echo " "
echo "---- run command: install rails_loki_exporter_dev-0.0.1.gem ----"
gem install rails_loki_exporter_dev-0.0.1.gem
