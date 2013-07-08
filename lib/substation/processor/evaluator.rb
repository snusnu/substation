module Substation
  module Processor

    # Abstract processor to evaluate a request coming into a chain
    class Evaluator

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
