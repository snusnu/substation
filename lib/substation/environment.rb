# encoding: utf-8

module Substation

  # The environment holding all registered {Chain} processors
  class Environment

    include Equalizer.new(:registry)
    include Adamantium::Flat

    # Build a new {Environment} instance
    #
    # @param [Proc] block
    #   a block to be instance_eval'ed with {DSL}
    #
    # @return [Environment]
    #
    # @api private
    def self.build(&block)
      new(DSL.registry(&block))
    end

    # Initialize a new instance
    #
    # @param [Hash<Symbol, #call>] registry
    #   the registry of processors
    #
    # @return [undefined]
    #
    # @api private
    def initialize(registry)
      @registry  = registry
      @chain_dsl = Chain::DSL::Builder.call(@registry)
    end

    # Build a new {Chain} instance
    #
    # @param [Chain] other
    #   the optional chain to build on top of
    #
    # @param [Proc] block
    #   a block to be instance_eval'ed in {Chain::DSL}
    #
    # @return [Chain]
    #
    # @api private
    def chain(other = Chain::EMPTY, &block)
      Chain.new(@chain_dsl.processors(other, &block))
    end

    protected

    # The registry used by this {Environment}
    #
    # @return [Hash<Symbol, #call>]
    #
    # @api private
    attr_reader :registry

  end # class Environment
end # module Substation
