# encoding: utf-8

module Substation

  # Encapsulates all registered actions and their observers
  #
  # The only protocol actions must support is +#call(request)+.
  # Actions are intended to be classes that handle one specific
  # application use case.
  class Dispatcher

    include Concord.new(:actions, :env)
    include Adamantium::Flat

    GUARD = DSL::Guard.new(EMPTY_ARRAY)

    # Return a new registry instance suitable for {Dispatcher}
    #
    # @return [DSL::Registry]
    #
    # @api private
    def self.new_registry
      DSL::Registry.new(GUARD)
    end

    # Invoke the action identified by +name+
    #
    # @example
    #
    #   module App
    #     class Environment
    #       def initialize(storage, logger)
    #         @storage, @logger = storage, logger
    #       end
    #     end
    #
    #     class SomeUseCase
    #       def self.call(request)
    #         data = perform_work
    #         request.success(data)
    #       end
    #     end
    #   end
    #
    #   storage    = SomeStorageAbstraction.new
    #   env        = App::Environment.new(storage, Logger.new($stdout))
    #   config     = { :some_use_case => { :action => App::SomeUseCase } }
    #   dispatcher = Substation::Dispatcher.coerce(config, env)
    #
    #   response = dispatcher.call(:some_use_case, :some_input)
    #   response.success? # => true
    #
    # @param [Symbol] name
    #   a registered action name
    #
    # @param [Object] input
    #   the input model instance to pass to the action
    #
    # @return [Response]
    #   the response returned when calling the action
    #
    # @raise [UnknownActionError]
    #   if no action is registered for +name+
    #
    # @api public
    def call(name, input)
      fetch(name).call(Request.new(name, env, input))
    end

    # Test wether a chain with the given +name+ is registered
    #
    # @param [Symbol] name
    #   the name of the chain to test for
    #
    # @return [Boolean]
    #
    # @api private
    def include?(name)
      actions.include?(name)
    end

    private

    # The action registered with +name+
    #
    # @param [Symbol] name
    #   a name for which an action is registered
    #
    # @return [#call]
    #   the callable registered for +name+
    #
    # @raise [UnknownActionError]
    #   if no action is registered with +name+
    #
    # @api private
    def fetch(name)
      actions.fetch(name) { raise(UnknownActionError.new(name)) }
    end

  end # class Dispatcher
end # module Substation
