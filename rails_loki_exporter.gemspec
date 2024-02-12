require File.expand_path('lib/rails_loki_exporter/version', __dir__)

Gem::Specification.new do |spec|
    spec.name                  = 'rails_loki_exporter'
    spec.version               = RailsLokiExporter::VERSION
    spec.authors               = ['planning.how', 'Oleg Ten', 'Assiya Kalykova']
    spec.email                 = ['info@planning.how']
    spec.summary               = 'Rails Loki exporter'
    spec.description           = 'Export logs for your Rails application to Loki instance and access them through Grafana dashboard.'
    spec.homepage              = 'https://github.com/planninghow/rails-loki-exporter'
    spec.license               = 'MIT'
    spec.platform              = Gem::Platform::RUBY
    spec.required_ruby_version = '>= 2.7.0'
    spec.files = Dir['README.md', 'lib/**/*.rb',
                     'rails_loki_exporter.gemspec',
                     'Gemfile']
    spec.extra_rdoc_files      = ['README.md']
    spec.require_paths         = ['lib']
    spec.add_dependency        'zeitwerk', '~> 2.4'
    spec.add_dependency        'rspec'
end
