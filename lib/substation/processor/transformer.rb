module Substation
  module Processor

    # A processor that transforms output data into something else
    class Transformer

      include Processor::Outgoing

      # Transform response data into something else
      #
      # @param [Response] response
      #   the response to process
      #
      # @return [Response]
      #
      # @api private
      def call(response)
        respond_with(response, handler.call(response))
      end

    end # class Wrapper
  end # module Processor
end # module Substation
