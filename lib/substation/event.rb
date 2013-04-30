module Substation

  # Abstract base class for events
  class Event

    # A registry for keeping track of event types by name
    class Registry

      # Initialize a new instance
      #
      # @return [undefined]
      #
      # @api private
      def initialize
        @entries = {}
      end

      # Register a new +kind+ of +event_class+
      #
      # @param [#to_sym] kind
      #   the name used to register +event_class+
      #
      # @param [Class<Substation::Event>] event_class
      #   the event class to register using +kind+
      #
      # @return [self]
      #
      # @api private
      def register(kind, event_class)
        @entries[kind.to_sym] = event_class
        self
      end

      # The name used to register +event_class+
      #
      # @param [Class<Substation::Event>] event_class
      #   the +kind+ of event class
      #
      # @return [Symbol]
      #
      # @api private
      def kind(event_class)
        @entries.key(event_class)
      end

    end

    include Equalizer.new(
      :date,
      :action_name,
      :actor,
      :request_data,
      :response_data,
      :kind
    )

    include Adamantium
    include AbstractType

    # The registry keeping track of events
    REGISTRY = Registry.new

    # Register the receiving class using +name+
    #
    # @param [#to_sym] name
    #   the name used to register the receiving class
    #
    # @return [self]
    #
    # @api private
    def self.register_as(name)
      REGISTRY.register(name, self)
      self
    end

    # The kind of event the receiving class is registered with
    #
    # @return [Symbol]
    #
    # @api private
    def self.kind
      REGISTRY.kind(self)
    end

    # The date this event occurred at
    #
    # @return [DateTime]
    #
    # @api private
    attr_reader :date

    # The name of the action that triggered the event
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :action_name

    # The actor performing the action that triggered the event
    #
    # @return [Object]
    #
    # @api private
    attr_reader :actor

    # The request data passed to the action that triggered the event
    #
    # @return [Action::Request]
    #
    # @api private
    attr_reader :request_data

    # The response data returned from the action that triggered the event
    #
    # @return [Object]
    #
    # @api private
    attr_reader :response_data

    # The name this event is registered with
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :kind

    # Initialize a new instance
    #
    # @param [Action] action
    #   the action that triggered the event
    #
    # @param [DateTime] date
    #   the date at which the event was triggered
    #
    # @param [Object] response_data
    #   the data returned from calling +action+
    #
    # @return [undefined]
    #
    # @api private
    def initialize(action, date, response_data)
      @date          = date
      @action_name   = action.name
      @actor         = action.actor
      @request_data  = action.data
      @response_data = response_data
      @kind          = self.class.kind
    end

    # An event indicating success
    class Success < self
      register_as :success
    end

    # An event indicating failure
    class Failure < self
      register_as :failure
    end

  end # class Event
end # module SafePro
