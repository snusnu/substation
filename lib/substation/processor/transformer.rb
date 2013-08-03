# encoding: utf-8

module Substation
  module Processor

    # A processor that transforms output data into something else
    module Transformer

      # A transformer used to transform an incoming request
      class Incoming
        include Processor::Incoming

        # Call the processor
        #
        # @param [Request] request
        #   the request to process
        #
        # @return [Response::Success]
        #
        # @api private
        def call(request)
          request.success(execute(request))
        end
      end

      # A transformer used to transform an outgoing response
      class Outgoing
        include Processor::Outgoing

        # Call the processor
        #
        # @param [Response] response
        #   the response to process
        #
        # @return [Response]
        #   a new instance of the same class as +response+
        #
        # @api private
        def call(response)
          respond_with(response, execute(response))
        end
      end

    end # class Transformer
  end # module Processor
end # module Substation
