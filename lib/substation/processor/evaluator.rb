# encoding: utf-8

module Substation
  module Processor

    # Abstract processor to evaluate a request coming into a chain
    class Evaluator

      # A result object compatible with the {Evaluator} api contract
      class Result
        include AbstractType
        include Concord::Public.new(:output)

        # A successful evaluation result
        class Success < self
          include API::Success
        end # class Success

        # An errorneous evaluation result
        class Failure < self
          include API::Failure
        end # class Failure
      end # class Result

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

      # Processor to evaluate request input data
      class Data < self
        include Incoming

        private

        # Invoke the handler
        #
        # @param [Request] request
        #   the request to evaluate
        #
        # @return [Response]
        #
        # @api private
        def invoke(request)
          handler.call(request.input)
        end

      end

      # Processor to evaluate an incoming request
      class Request < self
        include Incoming
      end

      # Processor to evaluate a pivot chain handler
      class Pivot < self
        include Processor::Pivot

        private

        # Return a successful response
        #
        # @param [Request] _request
        #   the evaluated request
        #
        # @param [#output] result
        #   the evaluation result
        #
        # @return [Response::Success]
        #
        # @api private
        def on_success(_request, response)
          response
        end
      end

      include Adamantium::Flat
      include AbstractType

      # Evaluate a chain's request input data
      #
      # @param [Request] request
      #   the request to process
      #
      # @return [Response]
      #
      # @api private
      def call(request)
        result = invoke(request)
        if result.success?
          on_success(request, result)
        else
          on_failure(request, result)
        end
      end

      private

      # Invoke the handler
      #
      # @param [Request] request
      #   the request to evaluate
      #
      # @return [Response]
      #
      # @api private
      def invoke(request)
        handler.call(request)
      end

      # Return a successful response
      #
      # @param [Request] request
      #   the evaluated request
      #
      # @param [#output] result
      #   the evaluation result
      #
      # @return [Response::Success]
      #
      # @api private
      def on_success(request, result)
        request.success(result.output)
      end

      # Return a failure response by invoking a failure chain
      #
      # @param [Request] request
      #   the evaluated request
      #
      # @param [#output] result
      #   the evaluation result
      #
      # @return [Response::Failure]
      #
      # @api private
      def on_failure(request, result)
        failure_chain.call(request.error(result.output))
      end
    end # class Evaluator
  end # module Processor
end # module Substation
