# encoding: utf-8

module Substation
  module Processor
    class Evaluator
      class Result

        # A successful evaluation result
        class Success < self
          include Response::API::Success
        end # class Success

      end # class Result
    end # class Evaluator
  end # module Processor
end # module Substation
