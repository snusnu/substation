# encoding: utf-8

module Substation
  module Processor

    # A processor that wraps output data in a new handler instance
    module Wrapper

      # A wrapper used to wrap incoming request data
      class Incoming
        include Processor::Incoming
        include Wrapper

        def call(request)
          request.success(compose(request, invoke(request)))
        end
      end

      # A wrapper used to wrap outgoing response data
      class Outgoing
        include Processor::Outgoing
        include Wrapper

        def call(response)
          respond_with(response, compose(response, invoke(response)))
        end
      end

      include AbstractType
      include Adamantium::Flat

      abstract_method :call

      # Wrap response data in an instance of {#handler}
      #
      # @param [Response] response
      #   the response to process
      #
      # @return [Response]
      #
      # @api private
      def invoke(state)
        handler.new(decompose(state))
      end

    end # class Wrapper
  end # module Processor
end # module Substation
