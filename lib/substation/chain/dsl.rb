# encoding: utf-8

module Substation
  class Chain

    # The DSL class used to define chains in an {Environment}
    class DSL

      # The class that builds a DSL class suitable for an {Environment}
      class Builder

        # Builds a new {DSL} instance targeted for an {Environment},
        #
        # @param [Hash<Symbol, Processor::Builder>] registry
        #   the registry of processor builders used in an {Environment}
        #
        # @return [DSL]
        #
        # @api private
        def self.call(registry)
          new(registry).dsl
        end

        include Adamantium::Flat

        # The built {DSL} instance
        #
        # @return [DSL]
        #
        # @api private
        attr_reader :dsl

        # Initialize a new instance
        #
        # @param [Hash<Symbol, Processor::Builder>] registry
        #   the registry of processor builders to define methods for
        #
        # @return [undefined]
        #
        # @api private
        def initialize(registry)
          @registry   = registry
          @dsl_module = Module.new
          @dsl        = DSL.new(registry, compile_dsl_module)
        end

        private

        # Compile a new module for inclusion into a {DSL} instance
        #
        # @param [Hash<Symbol, Processor::Builder>] registry
        #   the registry of processor builders to define methods for
        #
        # @return [Module]
        #   a module with methods named after keys in +registry+
        #
        # @api private
        def compile_dsl_module
          @registry.each { |name, builder| define_dsl_method(name, builder) }
          @dsl_module
        end

        # Define a new instance method on the +dsl+ module
        #
        # @param [Symbol] name
        #   the name of the method
        #
        # @param [Processor::Builder] builder
        #   the processor builder to use within the chain
        #
        # @param [Module] dsl
        #   the module to define the method on
        #
        # @return [undefined]
        #
        # @api private
        def define_dsl_method(name, builder)
          @dsl_module.module_eval do
            define_method(name) { |handler, failure_chain = EMPTY|
              use(builder.call(handler, failure_chain))
            }
          end
        end

      end # class Builder

      include Equalizer.new(:registry, :definition)

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
      # @param [Hash<Symbol, Processor::Builder>] registry
      #   the registry of processor builders to define methods for
      #
      # @param [Module] dsl_module
      #   a module with methods named after keys in +registry+
      #
      # @param [Definition] definition
      #   the definition to use within a {Chain}
      #
      # @return [undefined]
      #
      # @api private
      def initialize(registry, dsl_module, definition = Definition::EMPTY)
        @registry   = registry
        @dsl_module = dsl_module
        @definition = definition

        extend(@dsl_module)
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
      # @param [#each<#call>] processors
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
        self.class.new(registry, @dsl_module, other.prepend(definition))
      end

    end # class DSL
  end # class Chain
end # module Substation
