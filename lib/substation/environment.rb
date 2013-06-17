module Substation

  class Environment

    class DSL

      attr_reader :registry

      def self.registry(&block)
        new(&block).registry
      end

      def initialize(&block)
        @registry = {}
        instance_eval(&block) if block
      end

      def register(name, processor)
        @registry[name] = processor
        self
      end
    end

    include Equalizer.new(:registry)
    include Adamantium::Flat

    def self.build(&block)
      new(DSL.registry(&block))
    end

    def initialize(registry)
      @registry  = registry
      @chain_dsl = Chain::DSL::Builder.call(@registry)
    end

    def chain(other = Chain::EMPTY, &block)
      Chain.build(@chain_dsl, other, &block)
    end

    protected

    attr_reader :registry
  end
end
