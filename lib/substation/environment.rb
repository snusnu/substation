module Substation

  # Encapsulates all registered {Action} instances and their observers
  class Environment

    # Encapsulates access to one registered {Substation::Action} instance
    class Action

      # Raised when no action class name is configured
      MissingClassError = Class.new(StandardError)

      # Coerce the given name and config to an {Action} instance
      #
      # @param [#to_sym] name
      #   the name for this action
      #
      # @param [Hash] config
      #   the configuration hash
      #
      # @return [Action]
      #   the coerced {Action} instance
      #
      # @api private
      def self.coerce(config)
        klass_name = config.fetch('action') { raise(MissingClassError) }
        observer   = Observer.coerce(config['observer'])

        new(Utils.const_get(klass_name), observer)
      end

      include Concord.new(:klass, :observer)
      include Adamantium

      # Call the action
      #
      # @see Substation::Action.call
      #
      # @param [*] args
      #   the args passed to {Substation::Action.call]
      #
      # @return [Substation::Response]
      #   the response returned from calling the action
      #
      # @api private
      def call(*args)
        response = klass.call(*args)
        observer.call(response)
        response
      end

    end # class Action

    # Raised when trying to dispatch to an unregistered action
    UnknownActionError = Class.new(StandardError)

    # Coerce the given +config+ to an {Environment} instance
    #
    # @param [Hash] config
    #   the environment configuration
    #
    # @return [Environment]
    #   the coerced {Environment} instance
    #
    # @api private
    def self.coerce(config)
      new(config.each_with_object({}) { |(name, config), actions|
        actions[name.to_sym] = Action.coerce(config)
      })
    end

    include Concord.new(:actions)
    include Adamantium

    # Invoke the action identified by +action_name+
    #
    # @param [Symbol] action_name
    #   a registered action name
    #
    # @param [Substation::Action::Request] request
    #   the request data to pass to the action
    #
    # @return [Substation::Response]
    #   the response returned from invoking the action
    #
    # @raise [KeyError]
    #   if no action is registered with +action_name+
    #
    # @api private
    def dispatch(action_name, request)
      fetch(action_name).call(self, request)
    end

    # The names of all registered {Substation::Action} instances
    #
    # @return [Set<Symbol>]
    #   the set of registered action names
    #
    # @api private
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

  end # class Environment
end # module Substation
