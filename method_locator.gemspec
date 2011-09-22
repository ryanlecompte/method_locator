# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "method_locator/version"

Gem::Specification.new do |s|
  s.name        = "method_locator"
  s.version     = MethodLocator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan LeCompte"]
  s.email       = ["lecompte@gmail.com"]
  s.homepage    = "http://github.com/ryanlecompte/method_locator"
  s.summary     = %q{method_locator provides a way to traverse an object's method lookup path to find all places where a method may be defined.}
  s.description = %q{method_locator provides a way to traverse an object's method lookup path to find all places where a method may be defined.}

  s.rubyforge_project = "method_locator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("rspec", "~> 2.5.0")
end
