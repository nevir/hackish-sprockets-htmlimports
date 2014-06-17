# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets/htmlimports/version'

Gem::Specification.new do |spec|
  spec.name          = 'sprockets-htmlimports'
  spec.version       = Sprockets::Htmlimports::VERSION
  spec.authors       = ['Ian MacLeod']
  spec.email         = ['ian@nevir.net']
  spec.summary       = %q{Sprockets support for HTML imports}
  spec.license       = 'BSD'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Until/if https://github.com/galdor/ruby-gumbo/pull/5 is merged, you must
  # require this gem via git. Add the following to your Gemfile:
  #
  #   gem 'ruby-gumbo', git: 'https://github.com/nevir/ruby-gumbo'
  #
  spec.add_runtime_dependency 'ruby-gumbo', '~> 1.1.rc1'
  spec.add_runtime_dependency 'sprockets', '~> 2.8'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'railties', '>= 4.0'
  spec.add_development_dependency 'rake'
end
