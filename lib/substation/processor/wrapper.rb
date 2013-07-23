# encoding: utf-8

module Substation
  module Processor

    # A processor that wraps output data in a new handler instance
    module Wrapper

      # A wrapper used to wrap incoming request data
      class Incoming < Transformer::Incoming
        include Wrapper
      end

      # A wrapper used to wrap outgoing response data
      class Outgoing < Transformer::Outgoing
        include Wrapper
      end

      private

      # Wrap response data in an instance of {#handler}
      #
      # @param [Response] response
      #   the response to process
      #
      # @return [Response]
      #
      # @api private
      def invoke(state)
        handler.new(state)
      end

    end # class Wrapper
  end # module Processor
end # module Substation
