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
    def self.build(app_env, actions = Dispatcher::Registry.new, &block)
      new(app_env, actions, chain_dsl(&block))
    end

    # Build a new environment on top of an +other+
    #
    # @param [Environment] other
    #   the environment to inherit from
    #
    # @param [Dispatcher::Registry] actions
    #   the mutable action registry
    #
    # @param [Proc] block
    #   a block to instance_eval inside a {DSL} instance
    #
    # @return [Environment]
    #
    # @api private
    def self.inherit(env, actions = Dispatcher::Registry.new, &block)
      env.merge(build(env.app_env, actions, &block))
    end

    # Build a new {Chain::DSL} instance
    #
    # @param [Proc] block
    #   a block to be instance_eval'ed in {DSL}
    #
    # @return {Chain::DSL}
    #
    # @api private
    def self.chain_dsl(&block)
      Chain::DSL.build(DSL.registry(&block))
    end

    private_class_method :chain_dsl

    # The application environment
    #
    # @return [Object]
    #
    # @api private
    attr_reader :app_env

    # The mutable action registry
    #
    # @return [Dispatcher::Registry]
    #
    # @api private
    attr_reader :actions

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
    def initialize(app_env, actions, chain_dsl)
      @app_env   = app_env
      @actions   = actions
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

    # Register a new chain under the given +name+
    #
    # @param [#to_sym] name
    #   the new chain's name
    #
    # @param [Chain] other
    #   the chain to build on top of
    #
    # @param [Chain] failure_chain
    #   the chain to invoke in case of uncaught exceptions in handlers
    #
    # @return [Chain]
    #   the registered chain
    #
    # @api private
    def register(name, other = Chain::EMPTY, failure_chain = Chain::EMPTY, &block)
      actions[name] = chain(other, failure_chain, &block)
      self
    end

    # Return the chain identified by +name+ or raise an error
    #
    # @param [name]
    #   the name of the chain to retrieve
    #
    # @return [Chain]
    #
    # @raise [UnknownActionError]
    #   if no chain is registered under +name+
    #
    # @api private
    def [](name)
      actions.fetch(name)
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
    def dispatcher
      Dispatcher.new(actions, app_env)
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
      self.class.new(app_env, other.actions, merged_chain_dsl(other))
    end

    private

    # Return a new {Chain::DSL} by merging in +other.registry+
    #
    # @param [Environment] other
    #   the other environment providing the registry to merge
    #
    # @return [Chain::DSL]
    #
    # @api private
    def merged_chain_dsl(other)
      Chain::DSL.build(registry.merge(other.registry))
    end
  end # class Environment
end # module Substation
