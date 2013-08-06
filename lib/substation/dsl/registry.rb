# encoding: utf-8

module Substation
  module DSL

    # A mutable registry for objects collected with DSL classes
    class Registry

      include Equalizer.new(:guard, :entries)
      include Enumerable

      # Coerce +name+ into a Symbol
      #
      # @param [#to_sym] name
      #   the name to coerce
      #
      # @return [Symbol]
      #
      # @api private
      def self.coerce_name(name)
        name.to_sym
      end

      # The guard responsible for rejecting invalid entries
      #
      # @return [Guard]
      #
      # @api private
      attr_reader :guard
      protected   :guard

      # The entries this registry stores
      #
      # @return [Hash<Symbol, Object>]
      #
      # @api private
      attr_reader :entries
      protected   :entries

      # Initialize a new instance
      #
      # @param [Guard] guard
      #   the guard to use for rejecting invalid entries
      #
      # @param [Hash<Symbol, Object>] entires
      #   the entries this registry stores
      #
      # @return [undefined]
      #
      # @api private
      def initialize(guard, entries = EMPTY_HASH)
        @guard, @entries = guard, entries.dup
      end

      # Iterate over all entries
      #
      # @param [Proc] block
      #   the block passed to #{entries}.each
      #
      # @yield [name, object]
      #
      # @yieldparam [Symbol] name
      #   the name of the current entry
      #
      # @yieldparam [Object] object
      #   the object registered by name
      #
      # @return [self]
      #
      # @api private
      def each(&block)
        return to_enum unless block
        entries.each(&block)
        self
      end

      # Return a new instance with +other+ merged in
      #
      # @param [Registry] other
      #   the registry to merge
      #
      # @raise [AlreadyRegisteredError]
      #   if any object in +other+ is already registered by the same
      #   name in +self+
      #
      # @return [Registry]
      #   the new, merged instance
      #
      # @api private
      def merge(other)
        other.each_with_object(new) { |(name, object), merged|
          merged[name] = object
        }
      end

      # Register +object+ by +name+
      #
      # @param [#to_sym] name
      #   the name to register object with
      #
      # @param [Object] object
      #   the object to register by +name+
      #
      # @raise [AlreadyRegisteredError]
      #   if +object+ is already registered by the same +name+
      #
      # @raise [ReservedNameError]
      #   if +object+ should be registered using a reserved +name+
      #
      # @return [Object]
      #   the registered object
      #
      # @api private
      def []=(name, object)
        coerced_name = coerce_name(name)
        guard.call(coerced_name, entries)
        entries[coerced_name] = object
      end

      # Test wether an object is registered by +name+
      #
      # @param [#to_sym] name
      #   the name to test
      #
      # @return [Boolean]
      #   true if an object is registered, false otherwise
      #
      # @api private
      def include?(name)
        entries.include?(coerce_name(name))
      end

      # Return the object registered by +name+ or the value returned from +block+
      #
      # @param [#to_sym] name
      #   the name of the object to fetch
      #
      # @param [Proc] block
      #   the block to invoke if no object is registered by +name+
      #
      # @return [Object]
      #
      # @api private
      def fetch(name, &block)
        entries.fetch(coerce_name(name), &block)
      end

      # Return all names by which objects are registered
      #
      # @return [Array<Symbol>]
      #
      # @api private
      def keys
        entries.keys
      end

      private

      # Coerce +name+ into a Symbol
      #
      # @param [#to_sym] name
      #   the name to coerce
      #
      # @return [Symbol]
      #
      # @api private
      def coerce_name(name)
        self.class.coerce_name(name)
      end

      # Return a new instance with {#guard} and {#entries}
      #
      # @return [Registry]
      #
      # @api private
      def new
        self.class.new(guard, entries)
      end
    end # class Registry
  end # module DSL
end # module Substation
