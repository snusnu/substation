module Substation

  # Implements a chain of responsibility for an action
  #
  # An instance of this class will typically contain (in that order)
  # a few processors that process the incoming {Request} object, one
  # processor that calls an action ({Processor::Pivot}), and some processors
  # that process the outgoing {Response} object.
  #
  # Both {Chain::Incoming} and {Chain::Outgoing} processors must
  # respond to `#call(response)` and `#result(response)`.
  #
  # @example chain processors (used in instance method examples)
  #
  #   module App
  #
  #     class Processor
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
  #     class Validator < Processor::Incoming
  #       def call(request)
  #         result = handler.call(request.input)
  #         if result.success?
  #           request.success(request.input)
  #         else
  #           request.error(result.output)
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
  #     class Presenter < Processor::Outgoing
  #       def call(response)
  #         respond_with(response, handler.new(response.output))
  #       end
  #     end
  #   end
  #
  class Chain

    include Enumerable
    include Concord.new(:processors)
    include Adamantium::Flat

    # Empty chain
    EMPTY = Class.new(self).new([])

    # Call the chain
    #
    # Invokes all processors and returns either the first
    # {Response::Failure} that it encounters, or if all
    # goes well, the {Response::Success} returned from
    # the last processor.
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
    #   the response returned from the last processor
    #
    # @return [Response::Failure]
    #   the response returned from the failing processor's failure chain
    #
    # @raise [Exception]
    #   any exception that isn't explicitly rescued in client code
    #
    # @api public
    def call(request)
      processors.inject(request) { |result, processor|
        response = processor.call(result)
        return response unless processor.success?(response)
        processor.result(response)
      }
    end

    # Iterate over all processors
    #
    # @param [Proc] block
    #   a block passed to {#handlers} each method
    #
    # @yield [handler]
    #
    # @yieldparam [#call] handler
    #   each handler in the chain
    #
    # @return [self]
    #
    # @api private
    def each(&block)
      return to_enum unless block
      processors.each(&block)
      self
    end

  end # class Chain
end # module Substation
