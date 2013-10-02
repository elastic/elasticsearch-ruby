# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/extensions/version'

Gem::Specification.new do |s|
  s.name          = "elasticsearch-extensions"
  s.version       = Elasticsearch::Extensions::VERSION
  s.authors       = ["Karel Minarik"]
  s.email         = ["karel.minarik@elasticsearch.org"]
  s.description   = %q{Extensions for the Elasticsearch Rubygem}
  s.summary       = %q{Extensions for the Elasticsearch Rubygem}
  s.homepage      = ""
  s.license       = "Apache 2"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "elasticsearch", '0.4.0'
  s.add_dependency "ansi"


  s.add_development_dependency "bundler", "> 1"
  s.add_development_dependency "rake"

  s.add_development_dependency "shoulda-context"
  s.add_development_dependency "mocha"
  s.add_development_dependency "turn"
  s.add_development_dependency "yard"
  s.add_development_dependency "ruby-prof"

  if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
    s.add_development_dependency "simplecov"
    s.add_development_dependency "cane"
    s.add_development_dependency "require-prof"
    s.add_development_dependency "coveralls"
  end
end
