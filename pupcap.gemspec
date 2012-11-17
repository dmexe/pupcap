# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pupcap/version"

Gem::Specification.new do |s|

  s.name        = "pupcap"
  s.version     = Pupcap::Version.to_s
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

  if s.respond_to? :specification_version then
    s.specification_version = 3
    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.12.0"])
      s.add_runtime_dependency(%q<vagrant>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<librarian-puppet>, [">= 0.9.7"])
      s.add_runtime_dependency(%q<net-ssh-multi>, [">= 1.1.0"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.12.0"])
      s.add_dependency(%q<vagrant>, [">= 1.0.0"])
      s.add_dependency(%q<librarian-puppet>, [">= 0.9.7"])
      s.add_dependency(%q<net-ssh-multi>, [">= 1.1.0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.12.0"])
    s.add_dependency(%q<vagrant>, [">= 1.0.0"])
    s.add_dependency(%q<librarian-puppet>, [">= 0.9.7"])
    s.add_dependency(%q<net-ssh-multi>, [">= 1.1.0"])
  end
end
