# encoding: utf-8

module Substation
  module Processor

    # Wraps {Processor} configuration
    class Config
      include Concord::Public.new(:executor, :failure_chain, :observers)

      # Add failure chain
      #
      # @param [Chain] chain
      #
      # @return [Processor]
      #
      # @api private
      def with_failure_chain(chain)
        self.class.new(executor, chain, observers)
      end

    end # class Config

  end # module Processor
end # module Substation
