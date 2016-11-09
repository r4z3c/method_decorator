$:.push File.expand_path('../lib', __FILE__)

require 'method_decorator/version'

Gem::Specification.new do |s|
  s.name        = 'method_decorator'
  s.version     = MethodDecorator::VERSION
  s.authors     = ['r4z3c']
  s.email       = ['r4z3c.43@gmail.com']
  s.homepage    = 'https://github.com/r4z3c/method_decorator.git'
  s.summary     = 'Overwrite methods preserving the original behavior'
  s.description = 'Provides a way to dynamically overwrite methods without losing original behavior'
  s.licenses    = %w(MIT)

  s.files = `git ls-files`.split("\n")
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.require_paths = %w(lib)

  s.add_dependency 'bundler', '~>1'
  s.add_dependency 'activesupport', '~>4'

  s.add_development_dependency 'rspec', '~>3'
  s.add_development_dependency 'simplecov', '~>0'
end
