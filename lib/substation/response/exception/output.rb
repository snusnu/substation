# encoding: utf-8

module Substation
  class Response
    class Exception < self

      # Wraps response data and an exception not caught from a handler
      class Output
        include Equalizer.new(:data)

        # Return the data available when +exception+ was raised
        #
        # @return [Object]
        #
        # @api private
        attr_reader :data

        # Return the exception instance
        #
        # @return [Class<StandardError>]
        #
        # @api private
        attr_reader :exception

        # Initialize a new instance
        #
        # @param [Object] data
        #   the data available when +exception+ was raised
        #
        # @param [Class<StandardError>] exception
        #   the exception instance raised from a handler
        #
        # @return [undefined]
        #
        # @api private
        def initialize(data, exception)
          @data, @exception = data, exception
        end

        private

        # Tests wether +other+ is comparable using +comparator+
        #
        # @param [Symbol] comparator
        #   the operation used for comparison
        #
        # @param [Object] other
        #   the object to test
        #
        # @return [Boolean]
        #
        # @api private
        def cmp?(comparator, other)
          super && exception.class.send(comparator, other.exception.class)
        end
      end # class Output
    end # class Exception
  end # class Response
end # module Substation
