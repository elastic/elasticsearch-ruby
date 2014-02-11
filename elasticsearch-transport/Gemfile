source 'https://rubygems.org'

# Specify your gem's dependencies in elasticsearch-transport.gemspec
gemspec

if File.exists? File.expand_path("../../elasticsearch-api/elasticsearch-api.gemspec", __FILE__)
  gem 'elasticsearch-api', :path => File.expand_path("../../elasticsearch-api", __FILE__), :require => false
end

if File.exists? File.expand_path("../../elasticsearch-extensions", __FILE__)
  gem 'elasticsearch-extensions', :path => File.expand_path("../../elasticsearch-extensions", __FILE__), :require => false
end

if File.exists? File.expand_path("../../elasticsearch/elasticsearch.gemspec", __FILE__)
  gem 'elasticsearch', :path => File.expand_path("../../elasticsearch", __FILE__), :require => false
end
