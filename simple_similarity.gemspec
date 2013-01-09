# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_similarity/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_similarity"
  gem.version       = SimpleSimilarity::VERSION
  gem.authors       = ["Ori Pekelman"]
  gem.email         = ["ori@pekelman.com"]
  gem.description   = %q{A simple (slow but beautiful) algorithm to find similar things}
  gem.summary       = %q{A simple (slow but beautiful) algorithm to find similar things}
  gem.homepage      = "https://github.com/OriPekelman/simple_similarity"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "celluloid"
  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "awesome_print"
  gem.add_development_dependency "colorize"
end
