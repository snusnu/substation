# encoding: utf-8

module Substation
  module Processor
    class Builder

      # Wraps {Processor} configuration
      class Config
        include Concord::Public.new(:handler, :failure_chain, :executor)

        def with_failure_chain(chain)
          self.class.new(handler, chain, executor)
        end
      end # class Config

    end # class Builder
  end # module Processor
end # module Substation
