# encoding: utf-8

module Substation
  class Chain
    class DSL

      # A configuration object used with a {DSL} instance
      class Config
        include Equalizer.new(:registry)

        # The registry of processor builders
        #
        # @return [Hash<Symbol, Processor::Builder>]
        #
        # @api private
        attr_reader :registry

        # A module exposing methods to build processors defined in {registry}
        #
        # @return [Module]
        #
        # @api private
        attr_reader :dsl_module

        # Initialize a new instance
        #
        # @param [Hash<Symbol, Processor::Builder>] registry
        #   the registry of processor builder instances
        #
        # @param [Module] dsl_module
        #   the module built by {Builder}, suitable for +registry+
        #
        # @return [undefined]
        #
        # @api private
        def initialize(registry, dsl_module)
          @registry, @dsl_module = registry, dsl_module
        end
      end # class Config
    end # class DSL
  end # class Chain
end # module Substation
