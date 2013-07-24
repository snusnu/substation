# encoding: utf-8

module Substation
  class Environment

    # The DSL class used to register processor builders
    class DSL

      # The registry of processor builders
      #
      # @return [Hash<Symbol, Processor::Builder>]
      #
      # @api private
      attr_reader :registry

      # The registry of processor builders
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Hash<Symbol, Processor::Builder>]
      #
      # @api private
      def self.registry(&block)
        new(&block).registry
      end

      # Initialize a new instance
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [undefined]
      #
      # @api private
      def initialize(&block)
        @registry = {}
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
        @registry[name.to_sym] = Processor::Builder.new(name, processor, executor)
        self
      end

    end # class DSL
  end # class Environment
end # module Substation
