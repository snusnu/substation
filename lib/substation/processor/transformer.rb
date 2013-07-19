# encoding: utf-8

module Substation
  module Processor

    # A processor that transforms output data into something else
    module Transformer

      # A transformer used to transform an incoming request
      class Incoming
        include Processor::Incoming
        include Processor::Call::Incoming
      end

      # A transformer used to transform an outgoing response
      class Outgoing
        include Processor::Outgoing
        include Processor::Call::Outgoing
      end

    end # class Transformer
  end # module Processor
end # module Substation
