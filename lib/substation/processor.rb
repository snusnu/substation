module Substation

  # Namespace for chain processors
  module Processor

    include Concord.new(:failure_chain, :handler)

    module Incoming
      include Processor
      include Chain::Incoming
    end

    module Outgoing
      include Processor
      include Chain::Outgoing
    end

  end # module Processor
end # module Substation
