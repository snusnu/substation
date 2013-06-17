module Substation

  class Chain

    def self.build(dsl, other, &block)
      new(dsl.processors(other, &block))
    end

    class DSL

      class Builder
        include Adamantium::Flat

        def self.call(registry)
          new(registry).dsl
        end

        attr_reader :dsl

        def initialize(registry)
          @registry = registry
          @dsl      = compile_dsl
        end

        private

        def compile_dsl
          @registry.each_with_object(Class.new(DSL)) { |(name, processor), dsl|
            define_dsl_method(name, processor, dsl)
          }
        end

        def define_dsl_method(name, processor, dsl)
          dsl.class_eval do
            define_method(name) { |*args| use(processor.new(*args)) }
          end
        end
      end

      attr_reader :processors

      def self.processors(chain, &block)
        new(chain, &block).processors
      end

      def initialize(processors, &block)
        @processors = []
        chain(processors)
        instance_eval(&block) if block
      end

      def use(processor)
        @processors << processor
        self
      end

      def chain(other)
        other.each { |handler| use(handler) }
        self
      end
    end
  end
end
