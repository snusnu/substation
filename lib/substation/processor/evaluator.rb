module Substation
  module Processor

    # A processor to evaluate a chain's request input data
    class Evaluator

      include Incoming

      # Initialize a new instance
      #
      # @param [Environment] env
      #   the substation environment used to build chains
      #
      # @param [#call] handler
      #   the handler to perform evaluation
      #
      # @param [Proc] block
      #   a block to construct a failure chain
      #
      # @return [undefined]
      #
      # @api private
      def initialize(env, handler, &block)
        @env, @handler = env, handler
        @failure_chain = block ? @env.chain(&block) : Undefined
      end

      # Evaluate a chain's request input data
      #
      # @param [Request] request
      #   the request to process
      #
      # @return [Response]
      #
      # @api private
      def call(request)
        result = handler.call(request.input)
        output = result.output
        if result.success?
          request.success(output)
        else
          response = request.error(output)
          if fail_safe?
            failure_chain.call(response)
          else
            response
          end
        end
      end

      protected

      # The handler used to perform evaluation
      #
      # @return [#call]
      #
      # @api private
      attr_reader :handler

      private

      # The chain to invoke if evaluation returned an error
      #
      # @return [Chain]
      #
      # @api private
      attr_reader :failure_chain

      # Test wether this evaluator has a failure chain
      #
      # @return [TrueClass] if a failure chain is registered
      # @return [FalseClass] otherwise
      #
      # @api private
      def fail_safe?
        !@failure_chain.equal?(Undefined)
      end
    end # class Evaluator
  end # module Processor
end # module Substation
