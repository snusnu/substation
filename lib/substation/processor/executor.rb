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

      def decompose(input)
        decomposer.call(input)
      end

      def compose(input, output)
        composer.call(input, output)
      end

    end # class Executor
  end # module Processor
end # module Substation
