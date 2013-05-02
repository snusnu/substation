# -*- encoding: utf-8 -*-

require File.expand_path('../lib/substation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "substation"
  gem.version     = Substation::VERSION.dup
  gem.authors     = [ "Martin Gamsjaeger (snusnu)" ]
  gem.email       = [ "gamsnjaga@gmail.com" ]
  gem.description = "Implement application boundary interfaces with dedicated classes"
  gem.summary     = gem.description
  gem.homepage    = "https://github.com/snusnu/substation"

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_dependency 'adamantium',          '~> 0.0.7'
  gem.add_dependency 'equalizer',           '~> 0.0.5'
  gem.add_dependency 'abstract_type',       '~> 0.0.5'
  gem.add_dependency 'concord',             '~> 0.0.3'

  gem.add_development_dependency 'bundler', '~> 1.3.5'
end
