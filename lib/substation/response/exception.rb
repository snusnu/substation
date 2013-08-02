# encoding: utf-8

module Substation
  class Response

    # An exception {Response}
    class Exception < self
      include API::Failure

      # Test wether processing raised an exception
      #
      # @return [true]
      #
      # @api private
      def exception?
        true
      end
    end # class Exception
  end # class Response
end # module Substation
