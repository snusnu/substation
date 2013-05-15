module Substation

  # Encapsulates all registered actions and their observers
  #
  # The only protocol actions must support is +#call(request)+.
  # Actions are intended to be classes that handle one specific
  # application use case.
  class Dispatcher

    # Encapsulates access to one registered action
    class Action

      # Raised when no action class name is configured
      MissingHandlerError = Class.new(StandardError)

      # Coerce the given +name+ and +config+ to an {Action} instance
      #
      # @param [Hash<Symbol, Object>] config
      #   the configuration hash
      #
      # @return [Action]
      #   the coerced instance
      #
      # @raise [MissingHandlerError]
      #   if no action handler is configured
      #
      # @raise [ArgumentError]
      #   if action or observer handlers are not coercible
      #
      # @api private
      def self.coerce(config)
        handler  = config.fetch(:action) { raise(MissingHandlerError) }
        observer = Observer.coerce(config[:observer])

        new(Utils.coerce_callable(handler), observer)
      end

      include Concord.new(:handler, :observer)
      include Adamantium::Flat

      # Call the action
      #
      # @param [Substation::Request] request
      #   the request passed to the registered action
      #
      # @return [Substation::Response]
      #   the response returned when calling the action
      #
      # @api private
      def call(request)
        response = handler.call(request)
        observer.call(response)
        response
      end

    end # class Action

    # Raised when trying to dispatch to an unregistered action
    UnknownActionError = Class.new(StandardError)

    # Coerce the given +config+ to a {Dispatcher} instance
    #
    # @example setup code for all the other examples
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
    #
    #     class SomeObserver
    #       def self.call(response)
    #         # do something
    #       end
    #     end
    #   end
    #
    #   storage = SomeStorageAbstraction.new
    #   env     = App::Environment.new(storage, Logger.new($stdout))
    #
    # @example without observers
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   }, env)
    #
    # @example with a single observer
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => {
    #       'action' => 'SomeUseCase',
    #       'observer' => 'SomeObserver'
    #     }
    #   }, env)
    #
    # @example with multiple observers
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => {
    #       'action' => 'SomeUseCase',
    #       'observer' => [
    #         'SomeObserver',
    #         'AnotherObserver'
    #       ]
    #     }
    #   }, env)
    #
    # @example with Symbol keys and const handlers
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     :some_use_case => {
    #       :action   => App::SomeUseCase,
    #       :observer => App::SomeObserver
    #     }
    #   }, env)
    #
    # @example with Symbol keys and proc handlers
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     :some_use_case => {
    #       :action   => Proc.new { |request| request.success(:foo) },
    #       :observer => Proc.new { |response| do_something }
    #     }
    #   }, env)
    #
    # @param [Hash<#to_sym, Object>] config
    #   the action configuration
    #
    # @param [Object] env
    #   the application environment
    #
    # @return [Dispatcher]
    #   the coerced instance
    #
    # @raise [Action::MissingHandlerError]
    #   if no action handler is configured
    #
    # @raise [ArgumentError]
    #   if action or observer handlers are not coercible
    #
    # @api public
    def self.coerce(config, env)
      new(normalize_config(config), env)
    end

    # Normalize the given +config+
    #
    # @param [Hash<#to_sym, Object>] config
    #   the action configuration
    #
    # @return [Hash<Symbol, Action>]
    #   the normalized config hash
    #
    # @raise [Action::MissingHandlerError]
    #   if no action handler is configured
    #
    # @raise [ArgumentError]
    #   if action or observer handlers are not coercible
    #
    # @api private
    def self.normalize_config(config)
      Utils.symbolize_keys(config).each_with_object({}) { |(name, hash), actions|
        actions[name] = Action.coerce(hash)
      }
    end

    private_class_method :normalize_config

    include Concord.new(:actions, :env)
    include Adamantium::Flat

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
    #   response = dispatcher.call(:some_use_case, :some_input, env)
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
      fetch(name).call(Request.new(env, input))
    end

    # The names of all registered actions
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
    #   dispatcher.action_names # => #<Set: {:some_use_case}>
    #
    # @return [Set<Symbol>]
    #   the set of registered action names
    #
    # @api public
    def action_names
      Set.new(actions.keys)
    end

    memoize :action_names

    private

    # The action registered with +name+
    #
    # @param [Symbol] name
    #   a name for which an action is registered
    #
    # @return [Action]
    #   the action configuration registered for +name+
    #
    # @raise [KeyError]
    #   if no action is registered with +name+
    #
    # @api private
    def fetch(name)
      actions.fetch(name) { raise(UnknownActionError) }
    end

  end # class Dispatcher
end # module Substation
