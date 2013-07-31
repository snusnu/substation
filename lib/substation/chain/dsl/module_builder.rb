# encoding: utf-8

module Substation
  class Chain
    class DSL

        # Builds a {Module} suitable for a {DSL} instance
        class ModuleBuilder

          # Builds a new {Module} targeted for a {DSL} instance
          #
          # @param [Hash<Symbol, Processor::Builder>] registry
          #   the registry of processor builders used in an {Environment}
          #
          # @return [Module]
          #
          # @api private
          def self.call(registry)
            new(registry).dsl_module
          end

          include Adamantium::Flat

          # A module suitable for inclusion in a {DSL} instance
          #
          # @return [Module]
          #
          # @api private
          attr_reader :dsl_module

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
            initialize_dsl_module
          end

          private

          # Compile a new module for inclusion into a {DSL} instance
          #
          # @param [Hash<Symbol, Processor::Builder>] registry
          #   the registry of processor builders to define methods for
          #
          # @return [undefined]
          #
          # @api private
          def initialize_dsl_module
            @registry.each { |pair| define_dsl_method(*pair) }
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

        end # class ModuleBuilder
    end # class DSL
  end # class Chain
end # module Substation
