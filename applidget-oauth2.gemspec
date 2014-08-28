# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'applidget/oauth2/version'

Gem::Specification.new do |spec|
  spec.name          = "applidget-oauth2"
  spec.version       = Applidget::Oauth2::VERSION
  spec.authors       = ["aymericbouzy", "rpechayre"]
  spec.email         = ["aymeric.bouzy@applidget.com"]
  spec.summary       = "Connect to Applidget Accounts"
  spec.description   = "A strategy to connect to Applidget Accounts based on the OAuth2 spec."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
