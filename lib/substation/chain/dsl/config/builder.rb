# encoding: utf-8

module Substation
  class Chain
    class DSL
      class Config

        # Builds a {Config} suitable for a {DSL} instance
        class Builder

          # Builds a new {Config} instance targeted for a {DSL} instance
          #
          # @param [Hash<Symbol, Processor::Builder>] registry
          #   the registry of processor builders used in an {Environment}
          #
          # @return [DSL]
          #
          # @api private
          def self.call(registry)
            new(registry).config
          end

          include Adamantium::Flat

          # Return a {Config} instance  suitable for a {DSL} instance
          #
          # @return [Config]
          #
          # @api private
          attr_reader :config

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
            @config     = Config.new(registry, compile_dsl_module)
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
      end # class Config
    end # class DSL
  end # class Chain
end # module Substation
