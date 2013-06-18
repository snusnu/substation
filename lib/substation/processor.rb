module Substation

  # Namespace for chain processors
  module Processor

    include AbstractType
    include Adamantium::Flat

    abstract_method :call
    abstract_method :result

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
