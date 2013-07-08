# encoding: utf-8

module Substation
  class Environment

    # The DSL class used to register processors
    class DSL

      # The registry of processors
      #
      # @return [Hash<Symbol, #call>]
      #
      # @api private
      attr_reader :registry

      # The registry of processors
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Hash<Symbol, #call>]
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

      # Register a new +processor+ using the given +name+
      #
      # @param [#to_sym] name
      #   the name to register the +processor+ for
      #
      # @param [#call] processor
      #   the processor to register for +name+
      #
      # @return [self]
      #
      # @api private
      def register(name, processor)
        @registry[name.to_sym] = processor
        self
      end

    end # class DSL
  end # class Environment
end # module Substation
