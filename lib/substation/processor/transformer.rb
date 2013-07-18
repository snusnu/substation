# encoding: utf-8

module Substation
  module Processor

    # A processor that transforms output data into something else
    module Transformer

      # A transformer used to transform an incoming request
      class Incoming
        include Processor::Incoming
        include Transformer

        def call(request)
          request.success(compose(request, invoke(request)))
        end
      end

      # A transformer used to transform an outgoing response
      class Outgoing
        include Processor::Outgoing
        include Transformer

        def call(response)
          respond_with(response, compose(response, invoke(response)))
        end
      end

      include AbstractType
      include Adamantium::Flat

      abstract_method :call

    end # class Transformer
  end # module Processor
end # module Substation
