# encoding: utf-8

module Substation

  # Encapsulates the application environment and an input model instance
  class Request

    include Concord.new(:name, :env, :input)
    include Processor::API::Responder.new(Response)
    include Adamantium::Flat

    # The name of the request
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :name

    # The application environment
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       request.env
    #     end
    #   end
    #
    # @return [Object]
    #
    # @api public
    attr_reader :env

    # The input passed to an action
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       request.input
    #     end
    #   end
    #
    # @return [Object]
    #
    # @api public
    attr_reader :input

    alias_method :data, :input

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
