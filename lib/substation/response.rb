module Substation

  # {Action} response base class
  #
  # @abstract
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
end
