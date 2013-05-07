module Substation

  # Implements the boundary interface to invoke application use cases
  class Action

    # Encapsulates an actor and a request model instance
    class Request
      include Concord.new(:actor, :data)
      include Adamantium
    end

    # Encapsulates {Action} response data
    class Response

      include AbstractType
      include Equalizer.new(:data, :actor, :input)
      include Adamantium

      # The data returned by an action
      #
      # @return [Object]
      #
      # @api private
      attr_reader :data

      # The action initiating actor
      #
      # @return [Object]
      #
      # @api private
      attr_reader :actor

      # The request model instance passed into the action
      #
      # @see Request#data
      #
      # @return [Object]
      #
      # @api private
      attr_reader :input

      # Initialize a new instance
      #
      # @param [Request] request
      #   the request passed to the action that returned this response
      #
      # @param [Object] data
      #   the data returned from the action that returned this response
      #
      # @return [undefined]
      #
      # @api private
      def initialize(request, data)
        @request = request
        @data    = data
        @actor   = @request.actor
        @input   = @request.data
      end

      # Indicates wether this is a successful response or not
      #
      # @return [Boolean]
      #   true if successful, false otherwise
      #
      # @api private
      abstract_method :success?

      # An errorneous {Response}
      class Failure < self

        # Tests wether this response was successful
        #
        # @return [false]
        #
        # @api private
        def success?
          false
        end
      end

      # A successful {Response}
      class Success < self

        # Tests wether this response was successful
        #
        # @return [true]
        #
        # @api private
        def success?
          true
        end
      end
    end

    # Instantiate and invoke an {Action} (subclass)
    #
    # @param [*args] args
    #   the arguments accepted by {Action#initialize}
    #
    # @return [Response]
    #   the response object returned by {#perform}
    #
    # @api private
    def self.call(*args)
      new(*args).call
    end

    include Equalizer.new(:data, :actor, :env)
    include AbstractType
    include Adamantium

    # The action initiating actor
    #
    # @return [Object]
    #   an instance encapsulating an application actor
    #
    # @api private
    attr_reader :actor

    # The request model instance passed into this action
    #
    # @return [Object]
    #   an object encapsulating all necessary input for this action
    #
    # @api private
    attr_reader :data

    # The environment providing access to the logger and the notifier
    #
    # @return [Environment]
    #
    # @api private
    attr_reader :env

    # Initialize a new instance
    #
    # @param [Environment] env
    #   the environment used to dispatch to this action
    #
    # @param [Request] request
    #   a request model instance for initializing a new action instance
    #
    # @return [undefined]
    #
    # @api private
    def initialize(env, request)
      @env, @request = env, request
      @actor = @request.actor
      @data  = @request.data
    end

    # Invoke the action
    #
    # Delegates work to {#perform} and wraps the return value
    #
    # @return [Response]
    #   {Response::Success} if successful, {Response::Error} otherwise
    #
    # @api private
    def call
      perform
    end

    memoize :call

    # Perform the action
    #
    # @return [Response]
    #   {Response::Success} if successful, {Response::Error} otherwise
    #
    # @return [Object]
    #
    # @api private
    abstract_method :perform

    private :perform

    private

    # Create a new successful response
    #
    # @param [Object] data
    #   the data associated with the response
    #
    # @return [Response::Success]
    #
    # @api private
    def success(data)
      respond_with(Response::Success, data)
    end

    # Create a new failure response
    #
    # @param [Object] data
    #   the data associated with the response
    #
    # @return [Response::Failure]
    #
    # @api private
    def error(data)
      respond_with(Response::Failure, data)
    end

    # Instantiate an instance of +klass+ and pass +data+
    #
    # @param [Response::Success, Response::Failure] klass
    #   the response class
    #
    # @param [Object] data
    #   the data returned from the action
    #
    # @return [Response]
    #
    # @api private
    def respond_with(klass, data)
      klass.new(@request, data)
    end

  end # class Action
end # module Substation
