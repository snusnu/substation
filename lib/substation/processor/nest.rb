# encoding: utf-8

module Substation
  module Processor

    # Namespace for processor that call a nested chain
    module Nest

      # An incoming processor that calls a nested chain
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
          state = invoke(decompose(request))

          case state
          when Request
            request.success(compose(request, request.success(state.data)))
          when Response::Success
            request.success(compose(request, state))
          when Response::Failure
            request.error(compose(request, state))
          else
            raise 'Illegal state returned from the invoked handler'
          end
        end

      end # class Incoming
    end # module Nest
  end # module Processor
end # module Substation
