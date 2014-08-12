# encoding: utf-8

module Substation
  module DSL

    # A mutable registry for objects collected with DSL classes
    class Registry

      include Concord.new(:guard, :items)
      include Lupo.enumerable(:items)

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

      # Initialize a new instance
      #
      # @param [Guard] guard
      #   the guard to use for rejecting invalid entries
      #
      # @param [Hash<Symbol, Object>] items
      #   the items this registry stores
      #
      # @return [undefined]
      #
      # @api private
      def initialize(guard, items = EMPTY_HASH)
        super(guard, items.dup)
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
        guard.call(coerced_name, items)
        items[coerced_name] = object
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
        items.include?(coerce_name(name))
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
        items.fetch(coerce_name(name), &block)
      end

      # Return all names by which objects are registered
      #
      # @return [Array<Symbol>]
      #
      # @api private
      def keys
        items.keys
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
        self.class.new(guard, items)
      end
    end # class Registry
  end # module DSL
end # module Substation
