#!/bin/bash

echo "---- run command: uninstall build rails_loki_exporter ----"
gem uninstall build rails_loki_exporter
echo " "
echo "---- run command: build rails_loki_exporter.gemspec ----"
gem build rails_loki_exporter.gemspec
echo " "
echo "---- run command: install rails_loki_exporter ----"
gem install rails_loki_exporter-1.0.5.gem
