# encoding: utf-8

class Demo
  module Core
    module Validator

      # substation support

      DECOMPOSER = ->(request) {
        request.input.data
      }

      COMPOSER = ->(request, output) {
        Input::Incomplete.new(request.input.session, output)
      }

      EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

    end
  end
end
