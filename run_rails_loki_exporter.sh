#!/bin/bash

echo "---- run command: uninstall build rails_loki_exporter ----"
gem uninstall build rails_loki_exporter
echo " "
echo "---- run command: build rails_loki_exporter.gemspec ----"
gem build rails_loki_exporter.gemspec
echo " "
echo "---- run command: install rails_loki_exporter-0.0.171.gem ----"
gem install rails_loki_exporter-0.0.171.gem
