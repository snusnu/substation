# encoding: utf-8

module Substation
  module Processor

    # A processor that wraps output data in a new handler instance
    class Wrapper

      include Processor::Outgoing
      include Adamantium::Flat

      # Wrap response data in an instance of {#handler}
      #
      # @param [Response] response
      #   the response to process
      #
      # @return [Response]
      #
      # @api private
      def call(response)
        respond_with(response, handler.new(response.data))
      end

    end # class Wrapper
  end # module Processor
end # module Substation
