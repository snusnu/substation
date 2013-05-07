module Substation

  # {Action} response base class
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
    # @see Request#input
    #
    # @return [Object]
    #
    # @api private
    attr_reader :input

    # The data returned by when invoking an action
    #
    # @return [Object]
    #
    # @api private
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
    # @return [Boolean]
    #   true if successful, false otherwise
    #
    # @api private
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
end
