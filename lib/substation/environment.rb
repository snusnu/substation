# encoding: utf-8

module Substation

  # The environment holding all registered {Chain} processors
  class Environment

    include Equalizer.new(:registry)
    include Adamantium::Flat

    # Build a new {Environment} instance
    #
    # @param [Object] app_env
    #   the application environment
    #
    # @param [Dispatcher::Registry] actions
    #   a mutable action registry
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

    # Inherit a new instance from self, merging the {Chain::DSL}
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
    def inherit(actions = Dispatcher::Registry.new, &block)
      self.class.new(app_env, actions, merged_chain_dsl(&block))
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

    private

    # Return a new {Chain::DSL} by merging in +other.registry+
    #
    # @param [Environment] other
    #   the other environment providing the registry to merge
    #
    # @return [Chain::DSL]
    #
    # @api private
    def merged_chain_dsl(&block)
      Chain::DSL.build(registry.merge(DSL.registry(&block)))
    end
  end # class Environment
end # module Substation
