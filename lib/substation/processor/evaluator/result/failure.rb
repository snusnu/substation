# encoding: utf-8

module Substation
  module Processor
    class Evaluator
      class Result

        # An errorneous evaluation result
        class Failure < self
          include Response::API::Failure
        end # class Failure

      end # class Result
    end # class Evaluator
  end # module Processor
end # module Substation
