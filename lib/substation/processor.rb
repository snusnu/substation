module Substation

  # Namespace for chain processors
  module Processor

    include Concord.new(:failure_chain, :handler)

    # Test wether chain processing should continue
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [true] for a successful response
    # @return [false] otherwise
    #
    # @api private
    def success?(response)
      response.success?
    end

    # The response passed on to the next processor in a {Chain}
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [Response]
    #   the response passed on to the next processor in a {Chain}
    #
    # @api private
    def result(response)
      response
    end

    module Incoming
      include Processor

      # The request passed on to the next processor in a {Chain}
      #
      # @param [Response] _response
      #   the response returned from invoking this processor
      #
      # @return [Request]
      #   the request passed on to the next processor in a {Chain}
      #
      # @api private
      def result(_response)
        super.to_request
      end
    end

    module Pivot
      include Processor
    end

    module Outgoing
      include Processor

      # Test wether chain processing should continue
      #
      # @param [Response] _response
      #   the response returned from invoking the processor
      #
      # @return [false]
      #
      # @api private
      def success?(_response)
        true
      end

      private

      # Build a new {Response} based on +response+ and +output+
      #
      # @param [Response] response
      #   the original response
      #
      # @param [Object] output
      #   the data to be wrapped within the new {Response}
      #
      # @return [Response]
      #
      # @api private
      def respond_with(response, output)
        response.class.new(response.request, output)
      end

    end # module Outgoing
  end # module Processor
end # module Substation
