# encoding: utf-8

module Substation
  class Chain

    # The DSL class used to define chains in an {Environment}
    class DSL

      # Build a new instance suitable for +registry+
      #
      # @param [Hash<Symbol, Processor>] registry
      #   the registry of processor builders to use in a {Chain}
      #
      # @param [Definition] definition
      #   the collection of processors to use in a {Chain}
      #
      # @return [DSL]
      #
      # @api private
      def self.build(registry, definition = Definition::EMPTY)
        new(Config::Builder.call(registry), definition)
      end

      include Equalizer.new(:registry, :definition)

      # The config for this instance
      #
      # @return [Config]
      #
      # @api private
      attr_reader :config

      # The definition to be used within a {Chain}
      #
      # @return [Definition]
      #
      # @api private
      attr_reader :definition

      # The registry used to build processors
      #
      # @return [Hash<Symbol, Processor::Builder>]
      #
      # @api private
      attr_reader :registry

      # Initialize a new instance
      #
      # Extends the new instance with methods defined in +config.dsl_module+.
      # Only happens during boot, once for every instantiated {Environment}.
      #
      # @param [Config] config
      #   a config for this instance
      #
      # @param [Definition] definition
      #   the definition to use within a {Chain}
      #
      # @return [undefined]
      #
      # @api private
      def initialize(config, definition)
        @config     = config
        @definition = definition
        @registry   = @config.registry

        extend(@config.dsl_module)
      end

      # Build a new {Chain} based on +other+, a +failure_chain+ and a block
      #
      # @param [Enumerable<#call>] other
      #   the processors to prepend
      #
      # @param [Chain] failure_chain
      #   the failure chain to invoke in case of an uncaught exception
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed inside the new {DSL} instance
      #
      # @return [Chain]
      #
      # @api private
      def build(other, failure_chain, &block)
        Chain.new(__call__(Definition.new(other), &block), failure_chain)
      end

      # Nest the given chain within another one
      #
      # @param [Enumerable<#call>] processors
      #   other processors to be nested within a {Definition}
      #
      # @return [self]
      #
      # @api private
      def chain(processors)
        processors.each(&method(:use))
        self
      end

      # Use +chain+ as the failure chain for the processor identified by +name+
      #
      # @param [Symbol] name
      #   the processor's name
      #
      # @param [Chain] failure_chain
      #   the failure chain to use for the processor identified by +name+
      #
      # @return [self]
      #
      # @api private
      def failure_chain(name, failure_chain)
        definition.replace_failure_chain(name, failure_chain)
        self
      end

      private

      # Use the given +processor+ within a chain
      #
      # @param [#call] processor
      #   a processor to use within a chain
      #
      # @return [self]
      #
      # @api private
      def use(processor)
        definition << processor
        self
      end

      # Return a new definition
      #
      # @param [Definition] other
      #   the definition to prepend
      #
      # @param [Proc] block
      #   a block to be instance_eval'd inside a new {DSL} instance
      #
      # @return [Definition]
      #   the definition to be used with a {Chain}
      #
      # @api private
      def __call__(other, &block)
        new(other).instance_eval(&block).definition
      end

      # Instantiate a new instance
      #
      # @param [Definition] other
      #   the definition to prepend
      #
      # @param [Proc] block
      #   a block to be instance_eval'd inside a new {DSL} instance
      #
      # @return [DSL]
      #
      # @api private
      def new(other)
        self.class.new(config, other.prepend(definition))
      end

    end # class DSL
  end # class Chain
end # module Substation
