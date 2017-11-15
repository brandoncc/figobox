# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "figobox/version"

Gem::Specification.new do |spec|
  spec.name          = "figobox"
  spec.version       = Figobox::VERSION
  spec.authors       = ["Brandon Conway"]
  spec.email         = ["brandoncc@gmail.com"]

  spec.summary       = "A tool which makes using figaro and nanobox for the same application easy"
  spec.description   = "For applications which already use figaro, this tool makes it easy to continue doing so when deploying the application using nanobox."
  spec.homepage      = "https://github.com/brandoncc/figobox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
