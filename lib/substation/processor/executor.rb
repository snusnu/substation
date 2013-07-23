# encoding: utf-8

module Substation
  module Processor

    # Supports executing new {Processor} handler instances
    class Executor

      include Concord.new(:decomposer, :composer)
      include Adamantium::Flat

      decompose = ->(input)         { input  }
      compose   = ->(input, output) { output }

      NULL = new(decompose, compose)

      # Decompose input
      #
      # @param [Object] input
      #   the input to decompose
      #
      # @return [Object]
      #
      # @api private
      def decompose(input)
        decomposer.call(input)
      end

      # Compose input and output
      #
      # @param [Object] input
      #   the input to compose from
      #
      # @param [Object] output
      #   the output to compose with
      #
      # @return [Object]
      #
      # @api private
      def compose(input, output)
        composer.call(input, output)
      end

    end # class Executor
  end # module Processor
end # module Substation
