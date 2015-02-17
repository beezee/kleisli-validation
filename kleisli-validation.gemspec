# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kleisli/validation'

Gem::Specification.new do |spec|
  spec.name          = "kleisli-validation"
  spec.version       = Kleisli::Validation::VERSION
  spec.authors       = ["Brian Zeligson"]
  spec.email         = ["brian.zeligson@gmail.com"]
  spec.summary       = %q{Validation Monad for Kleisli gem}
  spec.description   = %q{Validation is an Either which can accumulate
                          failures when used with the apply operator (*)
                          and a Semigroup on the Left.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_dependency "kleisli", "~> 0.2.6"
end
