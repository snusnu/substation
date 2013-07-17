source 'http://rubygems.org'

gemspec

group :test do
  gem 'oj',         '~> 2.0.13'
  gem 'multi_json', '~> 1.7.3'
  gem 'ducktrap',   '~> 0.0.1'
  gem 'vanguard',   '~> 0.0.3'
  gem 'anima',      '~> 0.0.6'
end

group :development do
  gem 'devtools', :git => 'https://github.com/rom-rb/devtools.git'
  eval File.read('Gemfile.devtools')
end
