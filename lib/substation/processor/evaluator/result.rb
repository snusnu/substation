# encoding: utf-8

module Substation
  module Processor
    class Evaluator

      # A result object compatible with the {Evaluator} api contract
      class Result
        include AbstractType
        include Concord::Public.new(:output)

        # A successful evaluation result
        class Success < self
          include Response::API::Success
        end # class Success

        # An errorneous evaluation result
        class Failure < self
          include Response::API::Failure
        end # class Failure
      end # class Result
    end # class Evaluator
  end # module Processor
end # module Substation
