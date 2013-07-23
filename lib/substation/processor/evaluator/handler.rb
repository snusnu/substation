# encoding: utf-8

module Substation
  module Processor
    class Evaluator

      # Helps returning an api compatible result from custom Evaluator handlers
      module Handler

        # Return a successful result
        #
        # @param [Object] output
        #   the data associated with the result
        #
        # @return [Result::Success]
        #
        # @api private
        def success(output)
          respond_with(Result::Success, output)
        end

        # Return an errorneous result
        #
        # @param [Object] output
        #   the data associated with the result
        #
        # @return [Result::Failure]
        #
        # @api private
        def error(output)
          respond_with(Result::Failure, output)
        end

        private

        # Return a new result subclass instance
        #
        # @param [Result::Success, Result::Failure] klass
        #   the result class
        #
        # @param [Object] output
        #   the data associated with the result
        #
        # @return [Response]
        #
        # @api private
        def respond_with(klass, output)
          klass.new(output)
        end

      end # module Handler
    end # class Evaluator
  end # module Processor
end # module Substation
