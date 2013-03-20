require 'devtools'
require 'substation'

Devtools.init_spec_helper

include Substation

RSpec.configure do |config|
  config.include(SpecHelper)
end
