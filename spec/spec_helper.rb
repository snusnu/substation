require 'backports'
require 'backports/basic_object' unless defined?(BasicObject)
require 'rubygems'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'pp'
require 'rspec'

require 'substation'

ENV['TZ'] = 'UTC'

%w[shared support].each do |name|
  Dir[File.expand_path("../#{name}/**/*.rb", __FILE__)].each do |file|
    require file
  end
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.include(SpecHelper)
end

include Substation
