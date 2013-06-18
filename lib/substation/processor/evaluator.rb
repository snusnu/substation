module Substation
  module Processor

    # A processor to evaluate a chain's request input data
    class Evaluator

      include Incoming
      include Concord.new(:handler)

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
          request.error(output)
        end
      end

    end # class Evaluator
  end # module Processor
end # module Substation
