require 'rubygems'
require 'rspec'

require 'substation'

ENV['TZ'] = 'UTC'

# require spec support files and shared behavior
Dir[File.expand_path('../shared/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|

end
