# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eet_cz/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-eet-cz'
  spec.version       = EET_CZ::VERSION
  spec.authors       = ['Jan Uhlar']
  spec.email         = ['ciihla@seznam.cz']

  spec.summary       = 'EET wrapper for ruby'
  spec.description   = 'EET wrapper for ruby'
  spec.homepage      = 'https://github.com/ciihla/ruby-eet-cz'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rubocop', '~> 0.46'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_runtime_dependency 'activesupport', '>= 4.2'
  spec.add_runtime_dependency 'activemodel', '>= 4.2'
  spec.add_runtime_dependency 'savon', '~> 2.12.0'
end
