# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'id_ecuador/version'

Gem::Specification.new do |spec|
  spec.name          = "id_ecuador"
  spec.version       = IdEcuador::VERSION
  spec.authors       = ["Mario Andrés Correa"]
  spec.email         = ["a@macool.me"]
  spec.description   = %q{Validate Ecuador's CI and RUC}
  spec.summary       = %q{Gem to validate Ecuador's CI and RUC}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
