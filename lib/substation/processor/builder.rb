# encoding: utf-8

module Substation
  module Processor

    # Supports building new {Processor} instances
    class Builder

      include Concord.new(:name, :klass, :executor)

      # Build processor
      #
      # @param [#call] handler
      # @param [Chain] failure_chain
      #
      # @return [Processor]
      #
      # @api private
      def call(handler, failure_chain, observers)
        klass.new(name, handler, Config.new(executor, failure_chain, observers))
      end

    end # class Builder

  end # module Processor
end # module Substation
