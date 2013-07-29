# encoding: utf-8

module Substation
  class Chain

    # Encapsulates an ordered list of {Processor} instances to be used
    # within an instance of {Chain}
    class Definition

      include Equalizer.new(:processors)
      include Enumerable

      # The message for {UnknownProcessor} exceptions
      UNKNOWN_PROCESSOR_MSG = 'No processor named %s is registered'.freeze

      # The processors used in this instance
      #
      # @return [Enumerable<#call>]
      #
      # @api private
      attr_reader :processors
      protected   :processors

      # Initialize a new instance
      #
      # @param [Enumerable<#call>] processors
      #   the processors to be used within this instance
      #
      # @return [undefined]
      #
      # @api private
      def initialize(processors = [])
        @processors = []
        processors.each(&method(:<<))
      end

      # Append +processor+ to {#processors}
      #
      # @param [#call] processor
      #   the processor to append
      #
      # @return [self]
      #
      # @api private
      def <<(processor)
        processors << processor
        self
      end

      # The following const MUST have #initialize and #<< defined already

      # An empty instance
      EMPTY = new(EMPTY_ARRAY).freeze

      # Replace the failure chain of the processor identified by +name+
      #
      # @param [Symbol] name
      #   the name of the processor
      #
      # @param [Chain] failure_chain
      #   the failure chain to use in the replaced processor
      #
      # @return [self]
      #
      # @api private
      def replace_failure_chain(name, failure_chain)
        replace_processor(self[name], failure_chain)
        self
      end

      # Iterate over all processors
      #
      # @param [Proc] block
      #   a block passed to #{processors} each method
      #
      # @yield [processor]
      #
      # @yieldparam [#call] processor
      #   each processor in this instance
      #
      # @return [self]
      #
      # @api private
      def each(&block)
        return to_enum unless block
        processors.each(&block)
        self
      end

      private

      # Return the processor identified by +name+
      #
      # @param [Symbol] name
      #   the processor's name
      #
      # @return [#call]
      #   the processor identified by +name+
      #
      # @raise [UnknownProcessor]
      #
      # @api private
      def [](name)
        detect(name) or raise(
          UnknownProcessor,
          UNKNOWN_PROCESSOR_MSG % name.inspect
        )
      end

      # Replace +processor+'s failure chain with +chain+
      #
      # @param [#call] processor
      #   the processor to replace
      #
      # @param [#call] chain
      #   the failure chain to use with the new replaced processor
      #
      # @return [undefined]
      #
      # @api private
      def replace_processor(processor, chain)
        processors[index(processor)] = processor.with_failure_chain(chain)
      end

      # Return the processor's index inside {#processors}
      #
      # @param [#call] processor
      #   the processor to get the index for
      #
      # @return [Integer]
      #
      # @api private
      def index(processor)
        processors.index(processor)
      end

      # Return the first processor with the given +name+
      #
      # @param [Symbol] name
      #   the name of the processor to detect
      #
      # @return [#call]
      #   if a processor with the given +name+ is registered
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      def detect(name)
        processors.detect { |processor| processor.name == name }
      end

    end # class Definition
  end # class Chain
end # module Substation
