require 'set'
require 'forwardable'

require 'adamantium'
require 'equalizer'
require 'abstract_type'
require 'concord'

# Substation can be thought of as a domain level request router. It assumes
# that every usecase in your application has a name and is implemented in a
# dedicated class that will be referred to as an *action* in the context of
# substation. The only protocol such actions must support is `#call(request)`.
#
# Actions can be registered under any given name which allows above
# layers to invoke any specific action if respective conditions are met.
# For example, an application could map an http route to a specific named
# action and pass relevant http params as input data.
#
# The contract for actions specifies that when invoked, actions can
# receive arbitrary input data which will be available in `request.input`.
# Additionally, `request.env` will contain an arbitrary object that
# represents your application environment and provides access to typically
# useful things like a logger or a storage engine abstraction.
#
# The contract further specifies that every action must return an instance
# of either `Substation::Response::Success` or `Substation::Response::Failure`.
# Again, arbitrary data can be associated with any kind of response, and will
# be available in `response.data`. In addition to that, `response.success?` is
# available and will indicate wether invoking your action was successful or not.
#
module Substation
end

require 'substation/request'
require 'substation/response'
require 'substation/observer'
require 'substation/dispatcher'
require 'substation/support/utils'
