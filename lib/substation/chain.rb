module Substation

  # Implements a chain of responsibility for an action
  #
  # An instance of this class will typically contain (in that order)
  # a few handlers that process the incoming {Request} object, one
  # handler that calls an action ({Chain::Pivot}), and some handlers
  # that process the outgoing {Response} object.
  #
  # Both {Chain::Incoming} and {Chain::Outgoing} handlers must
  # respond to `#call(response)` and `#result(response)`.
  #
  # @example chain handlers (used in instance method examples)
  #
  #   module App
  #
  #     class Handler
  #
  #       def initialize(handler = nil)
  #         @handler = handler
  #       end
  #
  #       protected
  #
  #       attr_reader :handler
  #
  #       class Incoming < self
  #         include Substation::Chain::Incoming
  #       end
  #
  #       class Outgoing < self
  #         include Substation::Chain::Outgoing
  #
  #         private
  #
  #         def respond_with(response, output)
  #           response.class.new(response.request, output)
  #         end
  #       end
  #     end
  #
  #     class Validator < Handler::Incoming
  #       def call(request)
  #         result = handler.call(request.input)
  #         if result.valid?
  #           request.success(request.input)
  #         else
  #           request.error(result.violations)
  #         end
  #       end
  #     end
  #
  #     class Pivot < Handler
  #       include Substation::Chain::Pivot
  #
  #       def call(request)
  #         handler.call(request)
  #       end
  #     end
  #
  #     class Presenter < Handler::Outgoing
  #       def call(response)
  #         respond_with(response, handler.new(response.output))
  #       end
  #     end
  #   end
  #
  class Chain

    # Supports chaining handlers processed before the {Pivot}
    module Incoming

      # The request passed on to the next handler in a {Chain}
      #
      # @example
      #
      # @param [Response] response
      #   the response returned from the previous handler in a {Chain}
      #
      # @return [Request]
      #   the request passed on to the next handler in a {Chain}
      #
      # @api private
      def result(response)
        Request.new(response.env, response.output)
      end
    end

    # Supports chaining the {Pivot} or handlers processed after the {Pivot}
    module Outgoing

      # The response passed on to the next handler in a {Chain}
      #
      # @param [Response] response
      #   the response returned from the previous handler in a {Chain}
      #
      # @return [Response]
      #   the response passed on to the next handler in a {Chain}
      #
      # @api private
      def result(response)
        response
      end
    end

    # Supports chaining the {Pivot} handler
    Pivot = Outgoing

    include Concord.new(:handlers)
    include Adamantium::Flat
    include Pivot # allow nesting of chains

    # Call the chain
    #
    # Invokes all handlers and returns either the first
    # {Response::Failure} that it encounters, or if all
    # goes well, the {Response::Success} returned from
    # the last handler.
    #
    # @example
    #
    #   module App
    #     SOME_ACTION = Substation::Chain.new [
    #       Validator.new(MY_VALIDATOR),
    #       Pivot.new(Actions::SOME_ACTION),
    #       Presenter.new(Presenters::SomePresenter)
    #     ]
    #
    #     env     = Object.new # your env would obviously differ
    #     input   = { 'name' => 'John' }
    #     request = Substation::Request.new(env, input)
    #
    #     response = SOME_ACTION.call(request)
    #
    #     if response.success?
    #       response.output # => the output wrapped in a presenter
    #     else
    #       response.output # => if validation, pivot or presenter failed
    #     end
    #   end
    #
    # @param [Request] request
    #   the request to handle
    #
    # @return [Response::Success]
    #   the response returned from the last handler
    #
    # @return [Response::Failure]
    #   the response returned from the failing handler
    #
    # @raise [Exception]
    #   any exception that isn't explicitly rescued in client code
    #
    # @api public
    def call(request)
      handlers.inject(request) { |result, handler|
        response = handler.call(result)
        return response unless response.success?
        handler.result(response)
      }
    end

  end # class Chain
end # module Substation
