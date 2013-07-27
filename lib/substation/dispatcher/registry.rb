# encoding: utf-8

module Substation
  class Dispatcher

    # Provides a minimal hash like interface that raises if duplicate
    # keys are registered. Useful for preventing accidental overwriting
    # of an already registered callable.
    class Registry

      ALREADY_REGISTERED_MSG = '%s is already registered'.freeze

      include Equalizer.new(:dispatch_table)

      # Return the underlying dispatch table
      #
      # @return [Hash<#to_sym, #call>
      #
      # @api private
      attr_reader :dispatch_table
      protected   :dispatch_table

      # Initialize a new instance
      #
      # @param [Hash<#to_sym, #call>] dispatch_table
      #   a dispatch table to initialize this instance with
      #
      # @return [undefined]
      #
      # @api private
      def initialize(dispatch_table = {})
        @dispatch_table = dispatch_table
      end

      # Register the given +callable+ under +name+
      #
      # @param [#to_sym] name
      #   the name to use for dispatching
      #
      # @param [#call] callable
      #   the object to call when dispatching +name+
      #
      # @return [#call] the registered +callable+
      #
      # @raise [AlreadyRegisteredError]
      #   if +callable+ is already registered under +name+
      #
      # @api private
      def []=(name, callable)
        coerced_name = name.to_sym
        raise_if_already_registered(coerced_name)
        dispatch_table[coerced_name] = callable
      end

      # Return the callable object registered under +name+
      #
      # @param [#to_sym] name
      #   the name the callable is registered under
      #
      # @param [Proc] block
      #   the block to evaluate if no callable is registered under +name+
      #
      # @return [#call]
      #   the callable registered under +name+
      #
      # @api private
      def fetch(name, &block)
        dispatch_table.fetch(name.to_sym, &block)
      end

      # The names of all registered actions
      #
      # @return [Array<Symbol>]
      #   the set of registered action names
      #
      # @api private
      def keys
        dispatch_table.keys
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
