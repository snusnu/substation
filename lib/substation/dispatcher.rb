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
      MissingClassError = Class.new(StandardError)

      # Coerce the given +name+ and +config+ to an {Action} instance
      #
      # @param [Hash<Symbol, Object>] config
      #   the configuration hash
      #
      # @return [Action]
      #   the coerced instance
      #
      # @api private
      def self.coerce(config)
        klass_name = config.fetch(:action) { raise(MissingClassError) }
        observer   = Observer.coerce(config[:observer])

        new(Utils.const_get(klass_name), observer)
      end

      include Concord.new(:klass, :observer)
      include Adamantium

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
        response = klass.call(request)
        observer.call(response)
        response
      end

    end # class Action

    # Raised when trying to dispatch to an unregistered action
    UnknownActionError = Class.new(StandardError)

    # Coerce the given +config+ to a {Dispatcher} instance
    #
    # @example without observers
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   })
    #
    # @example with a single observer
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => {
    #       'action' => 'SomeUseCase',
    #       'observer' => 'SomeObserver'
    #     }
    #   })
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
    #   })
    #
    # @param [Hash<#to_sym, Object>] config
    #   the action configuration
    #
    # @return [Dispatcher]
    #   the coerced instance
    #
    # @api public
    def self.coerce(config)
      new(normalize_config(config))
    end

    # Normalize the given +config+
    #
    # @param [Hash<#to_sym, Object>] config
    #   the action configuration
    #
    # @return [Hash<Symbol, Action>]
    #   the normalized config hash
    #
    # @api private
    def self.normalize_config(config)
      Utils.symbolize_keys(config).each_with_object({}) { |(name, hash), actions|
        actions[name] = Action.coerce(hash)
      }
    end

    private_class_method :normalize_config

    include Concord.new(:actions)
    include Adamantium

    # Invoke the action identified by +name+
    #
    # @example
    #
    #   module App
    #     class Environment
    #       def initialize(dispatcher, logger)
    #         @dispatcher, @logger = dispatcher, logger
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
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => { 'action' => 'App::SomeUseCase' }
    #   })
    #
    #   env = App::Environment.new(dispatcher, Logger.new($stdout))
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
    # @param [Object] env
    #   the application environment
    #
    # @return [Response]
    #   the response returned when calling the action
    #
    # @raise [UnknownActionError]
    #   if no action is registered for +name+
    #
    # @api public
    def call(name, input, env)
      fetch(name).call(Request.new(env, input))
    end

    # The names of all registered actions
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       data = perform_work
    #       request.success(data)
    #     end
    #   end
    #
    #   dispatcher = Substation::Dispatcher.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   })
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
