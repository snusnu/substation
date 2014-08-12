# encoding: utf-8

module Substation
  module DSL

    # A guard used for rejecting invalid names in {DSL}
    class Guard

      include Concord.new(:reserved_names)
      include Adamantium::Flat

      # Initialize a new instance
      #
      # @param [Enumerable<Symbol>] reserved_names
      #   a list of reserved names
      #
      # @return [undefined]
      #
      # @api private
      def initialize(reserved_names = EMPTY_ARRAY)
        super
      end

      # Raise if {#name} is either reserved or already registered
      #
      # @param [Symbol] name
      #   the name to test
      #
      # @param [#include?] registry
      #   the registry to test
      #
      # @raise [AlreadyRegisteredError]
      #   if +name+ is already registered
      #
      # @raise [ReservedNameError]
      #   if +name+ is a reserved name
      #
      # @return [undefined]
      #
      # @api private
      def call(name, registry)
        raise_if_already_registered(name, registry)
        raise_if_reserved(name)
      end

      private

      # Raise if +name+ is already included in {#names}
      #
      # @param [Symbol] name
      #   the name to test
      #
      # @raise [AlreadyRegisteredError]
      #
      # @return [undefined]
      #
      # @api private
      def raise_if_already_registered(name, registry)
        if registry.include?(name)
          raise AlreadyRegisteredError.new(name)
        end
      end

      # Raise if {Chain::DSL.methods} include +name+
      #
      # @param [Symbol] name
      #   the name to test
      #
      # @raise [ReservedNameError]
      #
      # @return [undefined]
      #
      # @api private
      def raise_if_reserved(name)
        if reserved_names.include?(name)
          raise ReservedNameError.new(name)
        end
      end

    end # class Guard
  end # module DSL
end # module Substation
