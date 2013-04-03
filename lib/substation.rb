require 'set'
require 'forwardable'

require 'adamantium'
require 'equalizer'
require 'descendants_tracker'
require 'abstract_type'
require 'concord'

module Substation

  # Represent an undefined argument
  Undefined = Object.new.freeze

end

require 'substation/action/registry'
require 'substation/action'
