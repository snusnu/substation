# encoding: utf-8

module Substation
  class Response

    # Namespace for modules that help with processor result compatibility
    module API

      # Indicate successful processing
      module Success

        # Test wether processing was successful
        #
        # @return [true]
        #
        # @api private
        def success?
          true
        end
      end

      # Indicate errorneous processing
      module Failure

        # Test wether processing was successful
        #
        # @return [false]
        #
        # @api private
        def success?
          false
        end
      end

    end # module API
  end # class Response
end # module Substation
