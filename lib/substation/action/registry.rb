module Substation
  class Action

    # A registry of all {Action} subclasses on the load path
    class Registry

      include Enumerable

      # Initialize a new instance
      #
      # @param [Set<Action>] entries
      #   a set of actions to register
      #
      # @return [undefined]
      #
      # @api private
      def initialize(entries = Set.new)
        @entries = entries
      end

      # Iterate over the registered actions
      #
      # @yield [action] the registered actions
      #
      # @yieldparam [Action] action
      #   the registered action that is yielded
      #
      # @return [self]
      #
      # @api private
      def each
        return to_enum unless block_given?
        @entries.each { |action| yield(action) }
        self
      end

      # Test wether the given action is registered
      #
      # @param [Action] action
      #   the action to test
      #
      # @return [Boolean]
      #   +true+ if +action+ is registered
      #
      # @api private
      def include?(action)
        @entries.include?(action)
      end

      # The number of registered actions
      #
      # @return [Integer]
      #
      # @api private
      def size
        @entries.size
      end
    end # class Registry
  end # class Action
end # module Substation
