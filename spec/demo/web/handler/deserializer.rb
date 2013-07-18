# encoding: utf-8

class Demo
  module Web
    module Handler

      class Deserializer
        extend  Core::Handler
        include Concord.new(:input)

        DECOMPOSER = ->(request) {
          request.input
        }

        COMPOSER = ->(request, output) {
          Core::Input::Incomplete.new(output.fetch('session'), output.fetch('data'))
        }

        EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

        def call
          {
            'session' => deserialize(input.fetch('session')),
            'data'    => deserialize(input.fetch('data'))
          }
        end

        private

        def deserialize(json)
          MultiJson.load(json)
        end
      end
    end
  end
end
