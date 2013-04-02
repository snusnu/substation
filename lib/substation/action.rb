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

      include Concord.new(:data)
      include AbstractType
      include Adamantium

      abstract_method :success?

      # An errorneous {Action::Response}
      class Error < self

        # Tests wether this response was successful
        #
        # @return [false]
        #
        # @api private
        def success?
          false
        end
      end

      # A successful {Action::Response}
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
    # @param [Request] request
    #   a request model instance for initializing a new action instance
    #
    # @return [Response]
    #   the response object returned by {#perform}
    #
    # @api private
    def self.call(request)
      new(request).call
    end

    include AbstractType
    include Adamantium

    # Read or write the request model class used for this action
    #
    # @param [Class]
    #   a class encapsulating all necessary input for this action
    #
    # @return [Class]
    #   the request model class for this action
    #
    # @api private
    def self.request_model(klass = Undefined)
      return @request_model if klass.equal?(Undefined)
      @request_model = klass
    end

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

    # Initialize a new instance
    #
    # @param [Request] request
    #   a request model instance for initializing a new action instance
    #
    # @return [undefined]
    #
    # @api private
    def initialize(request)
      @actor = request.actor
      @data  = request.data
    end

    # Invoke the action
    #
    # Delegates work to {#perform}
    #
    # @return [Response]
    #   the response object returned by {#perform}
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
    # @api private
    abstract_method :perform

    private :perform

  end # class Action
end # module Substation
