module Substation
  module Processor

    # A processor to invoke a chain's pivot handler
    class Pivot

      include Processor
      include Chain::Pivot
      include Concord.new(:handler)

      # Invoke a chain's pivot handler
      #
      # @param [Request] request
      #   the request to process
      #
      # @return [Response]
      #
      # @api private
      def call(request)
        handler.call(request)
      end

    end # class Caller
  end # module Processor
end # module Substation
