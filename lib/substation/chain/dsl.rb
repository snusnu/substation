# encoding: utf-8

module Substation
  class Chain

    # The DSL class used to define chains in an {Environment}
    class DSL

      # The class that builds a DSL class suitable for an {Environment}
      class Builder
        include Adamantium::Flat

        # Build a new {DSL} subclass targeted for an {Environment}
        #
        # @param [Hash<Symbol, #call>] registry
        #   the registry of processors used in an {Environment}
        #
        # @return [Class<DSL>]
        #
        # @api private
        def self.call(registry)
          new(registry).dsl
        end

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
          @registry = registry
          @dsl      = compile_dsl
        end

        private

        # Compile a new DSL class
        #
        # @return [Class<DSL>]
        #
        # @api private
        def compile_dsl
          @registry.each_with_object(Class.new(DSL)) { |(name, builder), dsl|
            define_dsl_method(name, builder, dsl)
          }
        end

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
            define_method(name) { |handler, failure_chain = Chain::EMPTY|
              use(builder.call(handler, failure_chain))
            }
          end
        end

      end # class Builder

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
      def self.build(other, failure_chain, &block)
        Chain.new(new(other, &block).processors, failure_chain)
      end

      UNKNOWN_PROCESSOR_MSG = 'No processor named %s is registered'.freeze

      include Equalizer.new(:processors)

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
      def initialize(processors, &block)
        @processors = []
        chain(processors)
        instance_eval(&block) if block
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
        @processors << processor
        self
      end

      # Nest the given chain within another one
      #
      # @param [#each<#call>] other
      #   another chain to be nested within a chain
      #
      # @return [self]
      #
      # @api private
      def chain(other)
        other.each { |processor| use(processor) }
        self
      end

      # Use +chain+ as the failure chain for the processor identified by +name+
      #
      # @param [Symbol] name
      #   the processor's name
      #
      # @param [#call] chain
      #   the failure chain to use for the processor identified by +name+
      #
      # @return [self]
      #
      # @api private
      def failure_chain(name, chain)
        replace_processor(processor(name), chain)
        self
      end

      # The processors to be used within a {Chain}
      #
      # @return [Array<#call>]
      #
      # @api private
      def processors
        @processors.dup.freeze
      end

      private

      # Return the processor identified by +name+
      #
      # @param [Symbol] name
      #   the processor's name
      #
      # @return [#call]
      #   the processor identified by +name+
      #
      # @return [nil]
      #   if no processor identified by +name+ is registered
      #
      # @api private
      def processor(name)
        detect(name) || raise_unknown_processor(name)
      end

      # Replace +processor+'s failure chain with +chain+
      #
      # @param [#call] processor
      # @param [#call] chain
      #
      # @return [undefined]
      #
      # @api private
      def replace_processor(processor, chain)
        @processors[index(processor)] = processor.with_failure_chain(chain)
      end

      # Return the processor's index inside #processors
      #
      # @param [#call] processor
      #
      # @return [Integer]
      #
      # @api private
      def index(processor)
        @processors.index(processor)
      end

      # Return the first processor with the given +name+
      #
      # @param [Symbol] name
      #   the name of the processor to detect
      #
      # @return [#call]
      #   if a processor with the given +name+ is registered
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      def detect(name)
        @processors.find { |processor| processor.name == name }
      end

      # Raise {UnknownProcessor}
      #
      # @param [Symbol] name
      #   the unknown processor's name
      #
      # @raise [UnknownProcessor]
      #
      # @return [undefined]
      #
      # @api private
      def raise_unknown_processor(name)
        raise UnknownProcessor, UNKNOWN_PROCESSOR_MSG % name.inspect
      end

    end # class DSL
  end # class Chain
end # module Substation
