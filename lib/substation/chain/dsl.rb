# encoding: utf-8

module Substation
  class Chain

    # The DSL class used to define chains in an {Environment}
    class DSL

      # The class that builds a DSL class suitable for an {Environment}
      class Builder
        class << self

          # Build a new {DSL} subclass targeted for an {Environment}
          #
          # @param [Hash<Symbol, #call>] registry
          #   the registry of processors used in an {Environment}
          #
          # @return [Class<DSL>]
          #
          # @api private
          def call(registry)
            new(registry).dsl
          end

          # Compile a new DSL class
          #
          # @return [Class<DSL>]
          #
          # @api private
          def dsl_module(registry)
            registry.each_with_object(Module.new) { |(name, builder), dsl|
              define_dsl_method(name, builder, dsl)
            }
          end

          private

          # Define a new instance method on the +dsl+ class
          #
          # @param [Symbol] name
          #   the name of the method
          #
          # @param [Processor::Builder] builder
          #   the processor builder to use within the chain
          #
          # @param [Class<DSL>] dsl
          #   the {DSL} subclass to define the method on
          #
          # @return [undefined]
          #
          # @api private
          def define_dsl_method(name, builder, dsl)
            dsl.class_eval do
              define_method(name) { |handler, failure_chain = EMPTY|
                use(builder.call(handler, failure_chain))
              }
            end
          end
        end

        include Adamantium::Flat

        # The built DSL subclass
        #
        # @return [Class<DSL>]
        #
        # @api private
        attr_reader :dsl

        # Initialize a new instance
        #
        # @param [Hash<Symbol, #call>] registry
        #   the registry of processors used in an {Environment}
        #
        # @return [undefined]
        #
        # @api private
        def initialize(registry)
          @dsl = DSL.new(registry, self.class.dsl_module(registry))
        end

      end # class Builder

      include Equalizer.new(:registry, :definition)

      # The definition to be used within a {Chain}
      #
      # @return [Array<#call>]
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
      # @param [#each<#call>] processors
      #   the processors to build on top of
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
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
      # @param [#each<#call>] other
      #   the processors to build on top of
      #
      # @param [Chain] failure_chain
      #   the failure chain to invoke in case of an uncaught exception
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Chain]
      #
      # @api private
      def build(other, failure_chain, &block)
        Chain.new(__call__(Definition.new(other), &block), failure_chain)
      end

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

      def __call__(other, &block)
        new(other, &block).definition
      end

      def new(other, &block)
        self.class.new(registry, @dsl_module, other.prepend(definition)).instance_eval(&block)
      end

    end # class DSL
  end # class Chain
end # module Substation
