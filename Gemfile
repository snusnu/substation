source 'http://rubygems.org'

gemspec

group :test do
  gem 'multi_json', '~> 1.8.0'
  gem 'ducktrap',   '~> 0.0.2', :git => 'https://github.com/mbj/ducktrap', :branch => 'master'
  gem 'vanguard',   '~> 0.0.4', :git => 'https://github.com/mbj/vanguard', :branch => 'master'
  gem 'anima',      '~> 0.2.0'
end

group :development do
  gem 'devtools', :git => 'https://github.com/rom-rb/devtools.git', :branch => 'master'
  eval File.read('Gemfile.devtools')
end
