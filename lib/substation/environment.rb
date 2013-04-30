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
      def self.coerce(name, config)
        klass_name = config.fetch('action') { raise(MissingClassError) }
        observers  = config.fetch('observers', EMPTY_HASH)

        new(name.to_sym, Utils.const_get(klass_name), Observers.coerce(observers))
      end

      include Adamantium
      include Concord.new(:name, :klass, :observers)

      # Call the action
      #
      # @see Substation::Action.call
      #
      # @param [*] args
      #   the args passed to {Substation::Action.call]
      #
      # @return [Substation::Action::Response]
      #   the response returned from calling the action
      #
      # @api private
      def call(*args)
        klass.call(*args)
      end

      # Notify all observers registered for the given event
      #
      # @param [Substation::Event] event
      #   the event to pass to the observers
      #
      # @return [self]
      #
      # @api private
      def notify(event)
        observers.notify(event)
        self
      end
    end # class Action

    # Encapsulates access to all observers registered for one {Substation::Action}
    class Observers

      # Coerce the given +config+ to an {Observers} instance
      #
      # @param [Hash] config
      #   the observer configuration
      #
      # @return [Observers]
      #   the coerced {Observers} instance
      #
      # @api private
      def self.coerce(config)
        new(config.each_with_object({}) { |(event, observers), hash|
          hash[event.to_sym] = observers.map { |name| Utils.const_get(name) }
        })
      end

      include Adamantium
      include Concord.new(:entries)

      # Notify all registered observers for the given event
      #
      # @param [Substation::Event] event
      #   the event to pass to the observers
      #
      # @return [self]
      #
      # @api private
      def notify(event)
        entries.fetch(event.kind, EMPTY_ARRAY).each do |observer|
          observer.call(event)
        end
        self
      end
    end # class Observers

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
      new(config.each_with_object({}) { |(name, action), actions|
        actions[name.to_sym] = Action.coerce(name, action)
      })
    end

    include Adamantium
    include Concord.new(:actions)

    # Invoke the action identified by +action_name+
    #
    # @param [Symbol] action_name
    #   a registered action name
    #
    # @param [Substation::Action::Request] request
    #   the request data to pass to the action
    #
    # @return [Substation::Action::Response]
    #   the response returned from invoking the action
    #
    # @raise [KeyError]
    #   if no action is registered with +action_name+
    #
    # @api private
    def dispatch(action_name, request)
      action(action_name).call(action_name, request, self)
    end

    # Notify all registered observers for the given event
    #
    # @param [Substation::Event] event
    #   the event to pass to the registered observers
    #
    # @return [self]
    #
    # @raise [KeyError]
    #   if no action is registered for the given +event+'s action
    #
    # @api private
    def notify(event)
      action(event.action_name).notify(event)
      self
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
    def action(name)
      actions.fetch(name)
    end
  end # class Environment
end # module Substation
