# encoding: utf-8

module Substation

  # Namespace for chain processors
  module Processor

    include Equalizer.new(:name, :config)
    include Adamantium::Flat

    # Initialize a new instance
    #
    # @param [Symbol] name
    #   the processor's name
    #
    # @param [Builder::Config] config
    #   the processor's configuration
    #
    # @return [undefined]
    #
    # @api private
    def initialize(name, config)
      @name          = name
      @config        = config
      @handler       = @config.handler
      @failure_chain = @config.failure_chain
      @executor      = @config.executor
    end

    # This processor's name
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :name

    # This processor's config
    #
    # @return [Builder::Config]
    #
    # @api private
    attr_reader :config

    # Test wether chain processing should continue
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [true] for a successful response
    # @return [false] otherwise
    #
    # @api private
    def success?(response)
      response.success?
    end

    # The response passed on to the next processor in a {Chain}
    #
    # @param [Response] response
    #   the response returned from invoking the processor
    #
    # @return [Response]
    #   the response passed on to the next processor in a {Chain}
    #
    # @api private
    def result(response)
      response
    end

    private

    attr_reader :handler
    attr_reader :failure_chain
    attr_reader :executor

    def execute(state)
      compose(state, invoke(decompose(state)))
    end

    # Transform response data into something else
    #
    # @param [Response] response
    #   the response to process
    #
    # @return [Response]
    #
    # @api private
    def invoke(state)
      handler.call(state)
    end

    # Decompose +input+ before processing
    #
    # @param [Request, Response] input
    #   the object to decompose
    #
    # @return [Object]
    #   the decomposed object
    #
    # @api private
    def decompose(input)
      executor.decompose(input)
    end

    # Compose a new object based on +input+ and +output+
    #
    # @param [Request, Response] input
    #   the input as it was before calling {#decompose}
    #
    # @param [Object] output
    #   the data used to compose a new object
    #
    # @return [Object]
    #   the composed object
    #
    # @api private
    def compose(input, output)
      executor.compose(input, output)
    end

    # Supports {Processor} instances with a defined failure {Chain}
    module Fallible

      # Return a new processor with +chain+ as failure_chain
      #
      # @param [#call] chain
      #   the failure chain to use for the new processor
      #
      # @return [#call]
      #
      # @api private
      def with_failure_chain(chain)
        self.class.new(name, config.with_failure_chain(chain))
      end
    end

    # Supports incoming {Processor} instances
    module Incoming
      include Processor
      include Fallible

      # The request passed on to the next processor in a {Chain}
      #
      # @param [Response] _response
      #   the response returned from invoking this processor
      #
      # @return [Request]
      #   the request passed on to the next processor in a {Chain}
      #
      # @api private
      def result(_response)
        super.to_request
      end
    end

    # Supports pivot {Processor} instances
    module Pivot
      include Processor
      include Fallible
    end

    # Supports outgoing {Processor} instances
    module Outgoing
      include Processor

      # Test wether chain processing should continue
      #
      # @param [Response] _response
      #   the response returned from invoking the processor
      #
      # @return [true]
      #
      # @api private
      def success?(_response)
        true
      end

      private

      # Build a new {Response} based on +response+ and +output+
      #
      # @param [Response] response
      #   the original response
      #
      # @param [Object] output
      #   the data to be wrapped within the new {Response}
      #
      # @return [Response]
      #
      # @api private
      def respond_with(response, output)
        response.class.new(response.request, output)
      end

    end # module Outgoing

    # Namespace for modules providing {#call} implementations
    module Call

      # Provides {Processor#call} for incoming processors
      module Incoming

        # Call the processor
        #
        # @param [Request] request
        #   the request to process
        #
        # @return [Response::Success]
        #
        # @api private
        def call(request)
          request.success(execute(request))
        end
      end

      # Provides {Processor#call} for outgoing processors
      module Outgoing

        # Call the processor
        #
        # @param [Response] response
        #   the response to process
        #
        # @return [Response]
        #   a new instance of the same class as +response+
        #
        # @api private
        def call(response)
          respond_with(response, execute(response))
        end
      end
    end

  end # module Processor
end # module Substation
