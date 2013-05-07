require 'set'
require 'forwardable'

require 'adamantium'
require 'equalizer'
require 'abstract_type'
require 'concord'

module Substation

  # An empty frozen hash
  EMPTY_HASH = {}.freeze

  # An empty frozen array
  EMPTY_ARRAY = [].freeze

end

require 'substation/request'
require 'substation/response'
require 'substation/observer'
require 'substation/environment'
require 'substation/support/utils'
