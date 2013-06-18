module Substation
  module Processor

    # A processor that wraps output data in a new handler instance
    class Wrapper

      include Outgoing
      include Concord.new(:handler)

      # Wrap response data in an instance of {#handler}
      #
      # @param [Response] response
      #   the response to process
      #
      # @return [Response]
      #
      # @api private
      def call(response)
        respond_with(response, handler.new(response.output))
      end

    end # class Wrapper
  end # module Processor
end # module Substation
