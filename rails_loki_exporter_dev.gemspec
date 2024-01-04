require File.expand_path('lib/rails_loki_exporter_dev/version', __dir__)

Gem::Specification.new do |spec|
    spec.name                  = 'rails_loki_exporter_dev'
    spec.version               = RailsLokiExporterDev::VERSION
    spec.authors               = ['Oleg Ten', 'Assiya Kalykova']
    spec.email                 = ['tennet0505@gmail.com']
    spec.summary               = 'Ruby for Grafana Loki'
    spec.description           = 'Attempt to make gem'
    spec.homepage              = 'https://rubygems.org/gems/hello_app_ak_gem'
    spec.license               = 'MIT'
    spec.platform              = Gem::Platform::RUBY
    spec.required_ruby_version = '>= 2.7.0'
    spec.files = Dir['README.md', 'lib/**/*.rb',
                     'rails_loki_exporter_dev.gemspec',
                     'Gemfile']
    spec.extra_rdoc_files      = ['README.md']
    spec.require_paths         = ['lib']
    spec.add_dependency        'zeitwerk', '~> 2.4'
    spec.add_dependency        'rspec'
end
