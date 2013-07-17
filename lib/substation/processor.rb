# encoding: utf-8

module Substation

  # Namespace for chain processors
  module Processor

    include Equalizer.new(:name, :config)

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

    protected

    attr_reader :handler
    attr_reader :failure_chain
    attr_reader :executor

    private

    # Transform response data into something else
    #
    # @param [Response] response
    #   the response to process
    #
    # @return [Response]
    #
    # @api private
    def invoke(state)
      handler.call(decompose(state))
    end

    def decompose(input)
      executor.decompose(input)
    end

    def compose(input, output)
      executor.compose(input, output)
    end

    # Supports building new {Processor} instances
    class Builder

      # Wraps {Processor} configuration
      class Config
        include Concord::Public.new(:handler, :failure_chain, :executor)

        def with_failure_chain(chain)
          self.class.new(handler, chain, executor)
        end
      end

      include Concord.new(:name, :klass, :executor)

      def call(handler, failure_chain)
        klass.new(name, Config.new(handler, failure_chain, executor))
      end
    end

    # Supports executing new {Processor} handler instances
    class Executor

      include Concord.new(:decomposer, :composer)
      include Adamantium::Flat

      decompose = ->(input)         { input  }
      compose   = ->(input, output) { output }

      NULL = new(decompose, compose)

      def decompose(input)
        decomposer.call(input)
      end

      def compose(input, output)
        composer.call(input, output)
      end
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

    # Namespace for modules that help with processor api compatibility
    module API

      # Indicate successful processing
      module Success

        # Test wether evaluation was successful
        #
        # @return [true]
        #
        # @api private
        def success?
          true
        end
      end

      # Indicate errorneous processing
      module Failure

        # Test wether evaluation was successful
        #
        # @return [false]
        #
        # @api private
        def success?
          false
        end
      end
    end
  end # module Processor
end # module Substation
