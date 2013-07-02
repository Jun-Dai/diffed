# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diffl/version'

Gem::Specification.new do |gem|
  gem.name          = "diffl"
  gem.version       = Diffl::VERSION
  gem.authors       = ["Jun-Dai Bates-Kobashigawa"]
  gem.email         = ["jundai@kurutta.net"]
  gem.description   = %q{This is a library for creating HTML from a unified diff string, } + 
    %q{built specifically for the diff section output by "perforce describe -du", but with an eye towards solving a more general problem.}
  gem.summary       = %q{This is a library for creating HTML from a unified diff string}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "rspec"
end
