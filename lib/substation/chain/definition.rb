# encoding: utf-8

module Substation
  class Chain

    # Encapsulates an ordered list of {Processor} instances to be used
    # within an instance of {Chain}
    class Definition

      include Equalizer.new(:name, :processors)
      include Enumerable

      # The message for {UnknownProcessor} exceptions
      UNKNOWN_PROCESSOR_MSG = 'No processor named %s is registered'.freeze

      # The message for {DuplicateProcessorError} exceptions
      DUPLICATE_PROCESSOR_MSG = 'The following processors already exist within this chain: %s'

      # Initial array index to start incrementing from
      INITIAL_SEQUENCE_VALUE = -1

      # The chain of the chain
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :name

      # The processors used in this instance
      #
      # @return [Enumerable<#call>]
      #
      # @api private
      attr_reader :processors
      protected   :processors

      # The index tracking indices in {#processors} by processor name
      #
      # @return [Hash<Symbol, Array<Integer>>]
      #
      # @api private
      attr_reader :index
      private     :index

      # Initialize a new instance
      #
      # @param [Enumerable<#call>] processors
      #   the processors to be used within this instance
      #
      # @return [undefined]
      #
      # @api private
      def initialize(name = nil, processors = EMPTY_ARRAY)
        @name = name
        @processors, @index = [], Hash.new { |hash, key| hash[key] = [] }
        @sequence = INITIAL_SEQUENCE_VALUE
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
        raise_duplicate_processor_error([processor]) if include?(processor)
        processors << processor
        index[processor.name] << next_index
        self
      end

      # The following const MUST have #initialize and #<< defined already

      # An empty instance
      EMPTY = new.freeze

      # Replace the failure chain of the processor identified by +name+
      #
      # @param [Symbol] processor_name
      #   the name of the processor
      #
      # @param [Chain] failure_chain
      #   the failure chain to use in the replaced processor
      #
      # @return [self]
      #
      # @api private
      def replace_failure_chain(processor_name, failure_chain)
        idx = fetch(processor_name)
        processors[idx] = processors[idx].with_failure_chain(failure_chain)
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

      # Returns a new instance with +other+'s processors prepended
      #
      # @param [Definition] other
      #   the definition to prepend
      #
      # @return [Definition]
      #
      # @api private
      def prepend(other)
        duplicates = processors & other.processors
        raise_duplicate_processor_error(duplicates) if duplicates.any?
        self.class.new(name, other.processors | processors)
      end

      private

      # Return the first index for a processor with the given +name+
      #
      # @param [Symbol] name
      #   the processor's name
      #
      # @return [Integer]
      #
      # @raise [UnknownProcessor]
      #
      # @api private
      def fetch(processor_name)
        index.fetch(processor_name) {
          raise UnknownProcessor, UNKNOWN_PROCESSOR_MSG % processor_name.inspect
        }.first
      end

      # Raise {DuplicateProcessorError} with a message tailored for +dupes+
      #
      # @param [Processor, Array<Processor>] dupes
      #   one or many duplicate processors
      #
      # @raise [DuplicateProcessorError]
      #
      # @api private
      def raise_duplicate_processor_error(dupes)
        raise DuplicateProcessorError, DUPLICATE_PROCESSOR_MSG % dupes.inspect
      end

      # Return the next available index in {#processors}
      #
      # @return [Integer]
      #
      # @api private
      def next_index
        @sequence += 1
      end

    end # class Definition
  end # class Chain
end # module Substation
