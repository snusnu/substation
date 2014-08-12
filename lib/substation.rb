# encoding: utf-8

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
# The contract for actions specifies that when invoked, actions can
# receive arbitrary input data which will be available in `request.input`.
# Additionally, `request.env` contains an arbitrary object that
# represents your application environment and will typically provide access
# to useful things like a logger or a storage engine abstraction.
#
# The contract further specifies that every action must return an instance
# of either `Substation::Response::Success` or `Substation::Response::Failure`.
# Again, arbitrary data can be associated with any kind of response, and will
# be available in `response.data`. In addition to that, `response.success?` is
# available and will indicate wether invoking the action was successful or not.
#
# `Substation::Dispatcher` stores a mapping of action names to the actual
# objects implementing the action. Clients can use
# `Substation::Dispatcher#call(name, input, env)` to dispatch to any
# registered action. For example, a web application could map an http
# route to a specific action name and pass relevant http params on to the
# action.

module Substation

  # Represent an undefined argument
  Undefined = Object.new.freeze

  # An empty frozen array useful for (default) parameters
  EMPTY_ARRAY = [].freeze

  # An empty frozen hash useful for (default) parameters
  EMPTY_HASH = {}.freeze

  # Base class for substation errors
  class Error < StandardError
    def self.msg(object)
      self::MSG % object.inspect
    end

    def initialize(object)
      super(self.class.msg(object))
    end
  end # Error

  # Error raised when trying to access an unknown processor
  class UnknownProcessor < Error
    MSG = 'No processor named %s is registered'.freeze
  end # UnknownProcessor

  # Raised when trying to dispatch to an unregistered action
  class UnknownActionError < Error
    MSG = 'No action named %s is registered'.freeze
  end # UnknownActionError

  # Raised when an object is already registered under the a given name
  class AlreadyRegisteredError < Error
    MSG = '%s is already registered'.freeze
  end # AlreadyRegisteredError

  # Raised when a reserved method is being given
  class ReservedNameError < Error
    MSG = '%s is a reserved name'.freeze
  end # ReservedNameError

  # Raised when a duplicate {Processor} should be registered within a {Chain}
  class DuplicateProcessorError < Error
    MSG = 'The following processors already exist within this chain: %s'.freeze
  end # DuplicateProcessorError
end # Substation

require 'substation/request'
require 'substation/response'
require 'substation/response/api'
require 'substation/response/success'
require 'substation/response/failure'
require 'substation/response/exception'
require 'substation/response/exception/output'
require 'substation/processor'
require 'substation/processor/builder'
require 'substation/processor/config'
require 'substation/processor/executor'
require 'substation/processor/evaluator'
require 'substation/processor/evaluator/result'
require 'substation/processor/evaluator/handler'
require 'substation/processor/transformer'
require 'substation/processor/wrapper'
require 'substation/processor/nest'
require 'substation/dsl/guard'
require 'substation/dsl/registry'
require 'substation/chain/definition'
require 'substation/chain'
require 'substation/chain/dsl'
require 'substation/chain/dsl/config'
require 'substation/chain/dsl/module_builder'
require 'substation/environment'
require 'substation/environment/dsl'
require 'substation/dispatcher'
