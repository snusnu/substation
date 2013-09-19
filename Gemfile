source 'http://rubygems.org'

gemspec

group :test do
  gem 'multi_json', '~> 1.8.0'
  gem 'ducktrap',   '~> 0.0.2', :git => 'https://github.com/mbj/ducktrap'
  gem 'vanguard',   '~> 0.0.4', :git => 'https://github.com/mbj/vanguard'
  gem 'anima',      '~> 0.1.1'
end

group :development do
  gem 'devtools', :git => 'https://github.com/rom-rb/devtools.git'
  eval File.read('Gemfile.devtools')
end
