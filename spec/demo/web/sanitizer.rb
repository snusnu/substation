# encoding: utf-8

class Demo
  module Web

    module Sanitizer

      # substation support

      DECOMPOSER = ->(request) {
        request.input.data
      }

      COMPOSER = ->(request, output) {
        Core::Input::Incomplete.new(request.input.session, output)
      }

      EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      # sanitizers

      ID_TRAP = Ducktrap.build do
        custom do
          forward { |input| input.merge(:id => nil) }
          inverse { |input|
            input = input.dup
            input.delete(:id)
            input
          }
        end
      end

    end
  end
end
