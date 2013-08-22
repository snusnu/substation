source 'http://rubygems.org'

gemspec

group :test do
  gem 'multi_json', '~> 1.7.3'
  gem 'ducktrap',   '~> 0.0.1', :git => 'https://github.com/mbj/ducktrap'
  gem 'vanguard',   '~> 0.0.3', :git => 'https://github.com/mbj/vanguard'
  gem 'anima',      '~> 0.0.7'
end

group :development do
  gem 'devtools', :git => 'https://github.com/rom-rb/devtools.git'
  eval File.read('Gemfile.devtools')
end
