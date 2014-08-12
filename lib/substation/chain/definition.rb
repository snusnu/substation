# encoding: utf-8

module Substation
  class Chain

    # Encapsulates an ordered list of {Processor} instances to be used
    # within an instance of {Chain}
    class Definition

      include Equalizer.new(:name, :processors)
      include Lupo.enumerable(:processors)

      # The name of the chain
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

      # Initialize a new instance
      #
      # @param [Enumerable<#call>] processors
      #   the processors to be used within this instance
      #
      # @return [undefined]
      #
      # @api private
      def initialize(name, processors)
        @name, @processors = name, []
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
        self
      end

      # The following const MUST have #initialize and #<< defined already

      # An empty instance
      EMPTY = new(nil, EMPTY_ARRAY).freeze

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
        processors[idx] = processors.at(idx).with_failure_chain(failure_chain)
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

      # Return the index for a processor with the given +name+
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
        idx = processors.index {|processor| processor.name.equal?(processor_name)}
        idx or raise(UnknownProcessor.new(processor_name))
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
        raise DuplicateProcessorError.new(dupes)
      end

    end # class Definition
  end # class Chain
end # module Substation
