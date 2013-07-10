source 'http://rubygems.org'

gemspec

group :test do
  gem 'ducktrap'
  gem 'vanguard'
  gem 'anima'
end

group :development do
  gem 'devtools', :git => 'https://github.com/rom-rb/devtools.git'
  eval File.read('Gemfile.devtools')
end
