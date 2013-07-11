# encoding: utf-8

module Substation
  class Dispatcher

    # Class for supporting dispatch table construction
    class DSL

      ALREADY_REGISTERED_MSG = '%s is already registered'.freeze

      include Equalizer.new(:dispatch_table)

      # The dispatch table used to build a {Dispatcher} instance
      #
      # @return [Hash<Symbol, #call>]
      #
      # @api private
      attr_reader :dispatch_table

      # Initialize a new instance
      #
      # @param [Proc] block
      #   a block to be instance_eval'd
      #
      # @return [undefined]
      #
      # @api private
      def initialize(&block)
        @dispatch_table = {}
        instance_eval(&block) if block
      end

      # Register the given +callable+ under +name+
      #
      # @param [#to_sym] name
      #   the name to use for dispatching
      #
      # @param [#call] callable
      #   the object to call when dispatching +name+
      #
      # @return [self]
      #
      # @raise [AlreadyRegisteredError]
      #   if +callable+ is already registered under +name+
      #
      # @api private
      def dispatch(name, callable)
        coerced_name = name.to_sym
        raise_if_already_registered(coerced_name)
        dispatch_table[coerced_name] = callable
        self
      end

      private

      # Raise if +name+ is already registered in {#dispatch_table}
      #
      # @param [Symbol] name
      #   the name to test
      #
      # @raise [AlreadyRegisteredError]
      #
      # @return [undefined]
      #
      # @api private
      def raise_if_already_registered(name)
        if dispatch_table.key?(name)
          raise AlreadyRegisteredError, ALREADY_REGISTERED_MSG % name.inspect
        end
      end

    end # class DSL
  end # class Dispatcher
end # module Substation
