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

    module Incoming
      include Processor
      include Chain::Incoming
    end

    module Pivot
      include Processor
      include Chain::Pivot
    end

    module Outgoing
      include Processor
      include Chain::Outgoing

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
    end

  end # module Processor
end # module Substation
