module Substation

  class Chain

    # Build a new chain instance
    #
    # @param [DSL] dsl
    #   the dsl klass to use for defining the chain
    #
    # @param [Chain] other
    #   another chain to build on top of
    #
    # @param [Proc] block
    #   a block to instance_eval in the context of +dsl+
    #
    # @return [Chain]
    #
    # @api private
    def self.build(dsl, other, &block)
      new(dsl.processors(other, &block))
    end

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
          @registry.each_with_object(Class.new(DSL)) { |(name, processor), dsl|
            define_dsl_method(name, processor, dsl)
          }
        end


        # Define a new instance method on the +dsl+ class
        #
        # @param [Symbol] name
        #   the name of the method
        #
        # @param [#call] processor
        #   the processor to use within the chain
        #
        # @param [Class<DSL>] dsl
        #   the {DSL} subclass to define the method on
        #
        # @return [undefined]
        #
        # @api private
        def define_dsl_method(name, processor, dsl)
          dsl.class_eval do
            define_method(name) { |*args| use(processor.new(*args)) }
          end
        end

      end # class Builder

      # The processors to be used within a {Chain}
      #
      # @return [Array<#call>]
      #
      # @api private
      attr_reader :processors

      # The processors to be used within a {Chain}
      #
      # @param [Chain] chain
      #   the chain to build on top of
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Array<#call>]
      #
      # @api private
      def self.processors(chain, &block)
        new(chain, &block).processors
      end

      # Initialize a new instance
      #
      # @param [#each<#call>] processors
      #   an enumerable of processors to build on top of
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
        other.each { |handler| use(handler) }
        self
      end

    end # class DSL
  end # class Chain
end # module Substation
