module Substation

  # The environment holding all registered {Chain} processors
  class Environment

    # The DSL class used to define register processors
    class DSL

      # The registry of processors
      #
      # @return [Hash<Symbol, #call>]
      #
      # @api private
      attr_reader :registry


      # The registry of processors
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [Hash<Symbol, #call>]
      #
      # @api private
      def self.registry(&block)
        new(&block).registry
      end

      # Initialize a new instance
      #
      # @param [Proc] block
      #   a block to be instance_eval'ed
      #
      # @return [undefined]
      #
      # @api private
      def initialize(&block)
        @registry = {}
        instance_eval(&block) if block
      end

      # Register a new +processor+ using the given +name+
      #
      # @param [#to_sym] name
      #   the name to register the +processor+ for
      #
      # @param [#call] processor
      #   the processor to register for +name+
      #
      # @return [self]
      #
      # @api private
      def register(name, processor)
        @registry[name] = processor
        self
      end
    end

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
      Chain.build(@chain_dsl, other, &block)
    end

    protected

    # The registry used by this {Environment}
    #
    # @return [Hash<Symbol, #call>]
    #
    # @api private
    attr_reader :registry
  end
end
