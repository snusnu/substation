# encoding: utf-8

class Demo
  module Core
    module Handler
      include Adamantium::Flat

      def call(request)
        new(request).call
      end

      module Wrapper
        module Outgoing
          DECOMPOSER = ->(response) { response.data }
          COMPOSER   = ->(response, output) { output }
          EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)
        end
      end
    end
  end
end
