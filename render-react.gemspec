# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'render/react/version'

Gem::Specification.new do |spec|
  spec.name          = "render-react"
  spec.version       = Render::React::VERSION
  spec.authors       = ["Alexander Krasnoschekov"]
  spec.email         = ["akrasnoschekov@gmail.com"]

  spec.summary       = "Gem that renders react components into views"
  spec.homepage      = "https://gitlab.rambler.ru/rnd/render-react"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_dependency "mini_racer"
  spec.add_dependency "activesupport"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
