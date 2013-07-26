# -*- encoding: utf-8 -*-

require File.expand_path('../lib/substation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "substation"
  gem.version     = Substation::VERSION.dup
  gem.authors     = [ "Martin Gamsjaeger (snusnu)" ]
  gem.email       = [ "gamsnjaga@gmail.com" ]
  gem.description = "Implement application boundary interfaces with dedicated classes"
  gem.summary     = "Think of it as a domain level request router. It assumes that every usecase in your application has a name and is implemented in a dedicated action handler (class)."
  gem.homepage    = "https://github.com/snusnu/substation"

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO.md]

  gem.add_dependency 'adamantium',          '~> 0.0.10'
  gem.add_dependency 'equalizer',           '~> 0.0.5'
  gem.add_dependency 'abstract_type',       '~> 0.0.6'
  gem.add_dependency 'concord',             '~> 0.1.2'

  gem.add_development_dependency 'bundler', '~> 1.3.5'
end
