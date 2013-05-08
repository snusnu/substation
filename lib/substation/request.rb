module Substation

  # Encapsulates the {#env} and an {#input} model instance
  class Request

    include Concord.new(:env, :input)
    include Adamantium

    # Create a new successful response
    #
    # @example
    #
    #   class SomeUseCase
    #     def call(request)
    #       data = perform_use_case
    #       request.success(data)
    #     end
    #   end
    #
    # @param [Object] output
    #   the data associated with the response
    #
    # @return [Response::Success]
    #
    # @api public
    def success(output)
      respond_with(Response::Success, output)
    end

    # Create a new failure response
    #
    # @example
    #
    #   class SomeUseCase
    #     def call(request)
    #       error = perform_use_case
    #       request.error(error)
    #     end
    #   end
    #
    # @param [Object] output
    #   the data associated with the response
    #
    # @return [Response::Failure]
    #
    # @api public
    def error(output)
      respond_with(Response::Failure, output)
    end

    private

    # Instantiate an instance of +klass+ and pass +output+
    #
    # @param [Response::Success, Response::Failure] klass
    #   the response class
    #
    # @param [Object] output
    #   the data associated with the response
    #
    # @return [Response::Success, Response::Failure]
    #
    # @api private
    def respond_with(klass, output)
      klass.new(self, output)
    end

  end # class Request
end # module Substation
