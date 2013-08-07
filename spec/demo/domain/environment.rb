# encoding: utf-8

class Demo
  module Domain

    class Environment

      def self.build(name, storage, logger)
        coerced_name = name.to_sym
        klass = case coerced_name
        when :development
          Development
        when :test
          Test
        when :production
          Production
        end
        klass.new(coerced_name, storage, logger)
      end

      class Development < self
        def development?
          true
        end
      end

      class Test < self
        def test?
          true
        end
      end

      class Production < self
        def production?
          true
        end
      end

      include AbstractType
      include Concord::Public.new(:name, :storage, :logger)

      def development?
        false
      end

      def test?
        false
      end

      def production?
        false
      end
    end
  end
end
