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
      Chain.new(processors(other, &block))
    end

    protected

    # The registry used by this {Environment}
    #
    # @return [Hash<Symbol, #call>]
    #
    # @api private
    attr_reader :registry

    private

    # The processors collected via the chain dsl instance
    #
    # @param [Chain] other
    #   another chain to build upon
    #
    # @param [Proc] block
    #   the block to pass to {Chain::DSL#processors}
    #
    # @return [Hash<Symbol, #call>]
    #
    # @api private
    def processors(other, &block)
      @chain_dsl.processors(self, other, &block)
    end

  end # class Environment
end # module Substation
