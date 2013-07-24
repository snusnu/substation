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
      registry  = DSL.registry(&block)
      chain_dsl = Chain::DSL::Builder.call(registry)
      new(registry, chain_dsl)
    end

    # Initialize a new instance
    #
    # @param [Hash<Symbol, Processor::Builder>] registry
    #   the registry of processor builders
    #
    # @return [undefined]
    #
    # @api private
    def initialize(registry, chain_dsl)
      @registry, @chain_dsl = registry, chain_dsl
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
    # @see Dispatcher.build
    #
    # @param [Object] env
    #   the application environment
    #
    # @param [Proc] block
    #   a block to be instance_eval'd inside a {Dispatcher::DSL}
    #   instance
    #
    # @return [Dispatcher]
    #
    # @api private
    def dispatcher(env, &block)
      Dispatcher.build(env, &block)
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
