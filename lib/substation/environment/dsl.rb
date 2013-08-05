# encoding: utf-8

module Substation
  class Environment

    # The DSL class used to register processor builders
    class DSL

      # Rejects already registered and reserved names
      GUARD = Guard.new(Chain::DSL::BASE_METHODS)

      # The registry of processor builders
      #
      # @return [Hash<Symbol, Processor::Builder>]
      #
      # @api private
      attr_reader :registry

      # The guard to use for rejecting invalid names
      #
      # @return [Guard]
      #
      # @api private
      attr_reader :guard
      private     :guard

      # The registry of processor builders
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Hash<Symbol, Processor::Builder>]
      #
      # @api private
      def self.registry(guard = GUARD, &block)
        new(guard, &block).registry
      end

      # Initialize a new instance
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [undefined]
      #
      # @api private
      def initialize(guard, &block)
        @guard, @registry = guard, {}
        instance_eval(&block) if block
      end

      # Register a new +processor+ using the given +name+ and +executor+
      #
      # @param [#to_sym] name
      #   the name to register the +processor+ for
      #
      # @param [#call] processor
      #   the processor to register for +name+
      #
      # @param [Processor::Executor] executor
      #   the executor for +processor+
      #
      # @return [self]
      #
      # @api private
      def register(name, processor, executor = Processor::Executor::NULL)
        coerced_name = name.to_sym
        guard.call(coerced_name, registry)

        registry[coerced_name] =
          Processor::Builder.new(coerced_name, processor, executor)

        self
      end

    end # class DSL
  end # class Environment
end # module Substation
