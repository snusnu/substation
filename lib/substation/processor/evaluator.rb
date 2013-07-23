# encoding: utf-8

module Substation
  module Processor

    # Abstract processor to evaluate a request coming into a chain
    class Evaluator

      # Processor to evaluate an incoming request
      class Request < self
        include Processor::Incoming
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
        result = invoke(decompose(request))
        if result.success?
          on_success(request, result)
        else
          on_failure(request, result)
        end
      end

      private

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
        request.success(output(request, result))
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
        failure_chain.call(request.error(output(request, result)))
      end

      # Return a new composed output
      #
      # @param [Request] request
      #   the evaluated request
      #
      # @param [Response] response
      #   the evaluation result
      #
      # @return [Object]
      #
      # @api private
      def output(request, result)
        compose(request, result.output)
      end

    end # class Evaluator
  end # module Processor
end # module Substation
