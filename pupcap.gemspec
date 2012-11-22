# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pupcap/version"

Gem::Specification.new do |s|

  s.name        = "pupcap"
  s.version     = Pupcap::VERSION.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dmitry Galinsky"]
  s.email       = ["dima.exe@gmail.com"]
  s.homepage    = "http://github.com/dima-exe/pupcap"
  s.summary     = %q{under development}
  s.description = %q{under development description}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("capistrano", [">= 2.12.0"])
  s.add_runtime_dependency("vagrant", [">= 1.0.0"])
  s.add_runtime_dependency("librarian-puppet", [">= 0.9.7"])
  s.add_runtime_dependency("thor", [">= 0"])
end
