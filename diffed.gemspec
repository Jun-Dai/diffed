# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diffed/version'

Gem::Specification.new do |gem|
  gem.name          = "diffed"
  gem.version       = Diffed::VERSION
  gem.authors       = ["Jun-Dai Bates-Kobashigawa"]
  gem.email         = ["jundai@kurutta.net"]
  gem.description   = %q{This is a library for creating HTML from a unified diff string, built specifically for the diff section } +
    %q{output by "perforce describe -du" or "git show [commit SHA]", but with an eye towards solving a more general problem.  } +
    %q{It supports two modes: with inline styles or with CSS classes(which you can style yourself).  Either mode outputs an HTML table } +
    %q{that you may want to include in a Web page or an HTML e-mail.}
  gem.summary       = %q{This is a library for creating HTML from a unified diff string}
  gem.homepage      = "http://github.com/Jun-Dai/diffed"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "escape_utils"
  gem.add_development_dependency "rake"    
  gem.add_development_dependency "rspec"
end
