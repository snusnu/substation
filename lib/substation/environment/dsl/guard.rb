module Substation
  class Environment
    class DSL

      # A guard used for rejecting invalid names in {DSL}
      class Guard

        include Equalizer.new(:reserved_names)
        include Adamantium::Flat

        # Message for ReservedNameError
        RESERVED_NAME_MSG = '%s is a reserved name'.freeze

        # Message for AlreadyRegisteredError
        ALREADY_REGISTERED_MSG = '%s is already registered'.freeze

        # The list of reserved names
        #
        # @return [Enumerable<Symbol>]
        #
        # @api private
        attr_reader :reserved_names
        private     :reserved_names

        # Initialize a new instance
        #
        # @param [Enumerable<Symbol>] reserved_names
        #   a list of reserved names
        #
        # @return [undefined]
        #
        # @api private
        def initialize(reserved_names = EMPTY_ARRAY)
          @reserved_names = reserved_names
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
            raise AlreadyRegisteredError, ALREADY_REGISTERED_MSG % name.inspect
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
            raise ReservedNameError, RESERVED_NAME_MSG % name.inspect
          end
        end

      end # class Guard
    end # class DSL
  end # class Environment
end # module Substation
