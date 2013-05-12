module Substation

  # Base class for action responses
  #
  # @abstract
  class Response

    include AbstractType
    include Equalizer.new(:request, :output)
    include Adamantium

    # The environment used to return this response
    #
    # @return [Environment]
    #
    # @api private
    attr_reader :env

    # The request model instance passed into an action
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       data = perform_work
    #       request.success(data)
    #     end
    #   end
    #
    #   env = Substation::Environment.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   })
    #
    #   response = env.dispatch(:some_use_case, :input)
    #   response.input # => :input
    #
    # @see Request#input
    #
    # @return [Object]
    #
    # @api public
    attr_reader :input

    # The data wrapped inside an action {Response}
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       request.success(:output)
    #     end
    #   end
    #
    #   env = Substation::Environment.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   })
    #
    #   response = env.dispatch(:some_use_case, :input)
    #   response.output # => :output
    #
    # @return [Object]
    #
    # @api public
    attr_reader :output

    # Initialize a new instance
    #
    # @param [Request] request
    #   the request passed to the action that returned this response
    #
    # @param [Object] output
    #   the data returned from the action that returned this response
    #
    # @return [undefined]
    #
    # @api private
    def initialize(request, output)
      @request = request
      @env     = @request.env
      @input   = @request.input
      @output  = output
    end

    # Indicates wether this is a successful response or not
    #
    # @abstract
    #
    # @see Success#success?
    # @see Failure#success?
    #
    # @example
    #
    #   class SomeUseCase
    #     def self.call(request)
    #       request.success(:data)
    #     end
    #   end
    #
    #   env = Substation::Environment.coerce({
    #     'some_use_case' => { 'action' => 'SomeUseCase' }
    #   })
    #
    #   response = env.dispatch(:some_use_case, :input)
    #   response.class    # Substation::Response::Success
    #   response.success? # => true
    #
    # @return [Boolean]
    #   true if successful, false otherwise
    #
    # @api public
    abstract_method :success?

    protected

    # The request that lead to this response
    #
    # @return [Request]
    #
    # @api private
    attr_reader :request

    # An errorneous {Response}
    class Failure < self

      # Tests wether this response was successful
      #
      # @example
      #
      #   class SomeUseCase
      #     def self.call(request)
      #       request.error(:output)
      #     end
      #   end
      #
      #   env = Substation::Environment.coerce({
      #     'some_use_case' => { 'action' => 'SomeUseCase' }
      #   })
      #
      #   response = env.dispatch(:some_use_case, :input)
      #   response.success? # => false
      #
      # @return [false]
      #
      # @api public
      def success?
        false
      end
    end

    # A successful {Response}
    class Success < self

      # Tests wether this response was successful
      #
      # @example
      #
      #   class SomeUseCase
      #     def self.call(request)
      #       request.success(:data)
      #     end
      #   end
      #
      #   env = Substation::Environment.coerce({
      #     'some_use_case' => { 'action' => 'SomeUseCase' }
      #   })
      #
      #   response = env.dispatch(:some_use_case, :input)
      #   response.success? # => true
      #
      # @return [true]
      #
      # @api public
      def success?
        true
      end
    end
  end
end
