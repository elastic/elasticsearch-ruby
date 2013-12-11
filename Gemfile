source 'https://rubygems.org'

gem "bundler", "> 1"
gem "rake"

gem 'elasticsearch', :path => File.expand_path("../elasticsearch", __FILE__), :require => false
gem 'elasticsearch-extensions', :path => File.expand_path("../elasticsearch-extensions", __FILE__), :require => false

gem "pry"
gem "ansi"
gem "shoulda-context"
gem "mocha"
gem "turn"
gem "yard"
gem "ruby-prof"
gem "ci_reporter"

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  gem "simplecov"
  gem "cane"
  gem "require-prof"
  gem "coveralls"
end
