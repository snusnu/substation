# encoding: utf-8

module Substation

  # The environment holding all registered {Chain} processors
  class Environment

    include Equalizer.new(:registry)
    include Adamantium::Flat

    # Build a new {Environment} instance
    #
    # @param [Environment] other
    #   optional other environment to build on top of
    #
    # @param [Proc] block
    #   a block to be instance_eval'ed with {DSL}
    #
    # @return [Environment]
    #
    # @api private
    def self.build(other = Undefined, &block)
      instance = new(Chain::DSL.build(DSL.registry(&block)))
      other.equal?(Undefined) ? instance : other.merge(instance)
    end

    # The registry used by this {Environment}
    #
    # @return [Hash<Symbol, Processor::Builder>]
    #
    # @api private
    attr_reader :registry
    protected   :registry

    # Initialize a new instance
    #
    # @param [Chain::DSL] chain_dsl
    #   the chain dsl tailored for the environment
    #
    # @return [undefined]
    #
    # @api private
    def initialize(chain_dsl)
      @chain_dsl = chain_dsl
      @registry  = chain_dsl.registry
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
    def chain(other = Chain::EMPTY, failure_chain = Chain::EMPTY, &block)
      @chain_dsl.build(other, failure_chain, &block)
    end

    # Build a new {Action} instance
    #
    # @param [#call] handler
    #   the handler implementing the action
    #
    # @param [Enumerable<#call>] observers
    #   any number of observers
    #
    # @return [Action]
    #
    # @api private
    def action(handler, observers = EMPTY_ARRAY)
      Action.new(handler, observers)
    end

    # Build a new {Dispatcher} instance
    #
    # @see Dispatcher.new
    #
    # @param [Object] env
    #   the application environment
    #
    # @return [Dispatcher]
    #
    # @api private
    def dispatcher(dispatch_table, env)
      Dispatcher.new(dispatch_table, env)
    end

    # Return a new instance that has +other+ merged into +self+
    #
    # @param [Environment] other
    #   the other environment to merge in
    #
    # @return [Environment]
    #   the new merged instance
    #
    # @api private
    def merge(other)
      self.class.new(Chain::DSL.build(merged_registry(other)))
    end

    private

    # Return a new registry by merging in +other.registry+
    #
    # @param [Environment] other
    #   the other environment providing the registry to merge
    #
    # @return [Hash<Symbol, Processor::Builder>]
    #
    # @api private
    def merged_registry(other)
      registry.merge(other.registry)
    end
  end # class Environment
end # module Substation
