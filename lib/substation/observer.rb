module Substation

  # Abstract observer base class
  #
  # @abstract
  class Observer

    include AbstractType
    include Adamantium::Flat

    # Notify the observer
    #
    # @param [Response] response
    #   the response returned when calling the observed action
    #
    # @return [self]
    #
    # @api private
    abstract_method :call

    # Coerce +input+ to an instance of {Observer}
    #
    # @param [NilClass, String, Array<String>] input
    #   0..n observer class names
    #
    # @return [Observer::NULL, Object, Observer::Chain]
    #   a null observer, an observer object, or a chain of observers
    #
    # @api private
    def self.coerce(input)
      case input
      when NilClass
        NULL
      when String
        Utils.const_get(input)
      when Array
        Chain.new(input.map { |item| coerce(item) })
      else
        raise ArgumentError, "Uncoercible input: #{input.inspect}"
      end
    end

    # Null observer
    NULL = Class.new(self) { def call(_response); self; end; }.new.freeze

    # Chain of observers
    class Chain < self

      include Concord.new(:observers)

      # Notify the observer
      #
      # @param [Response] response
      #   the response returned when calling the observed action
      #
      # @return [self]
      #
      # @api private
      def call(response)
        observers.each do |observer|
          observer.call(response)
        end
        self
      end

    end # Chain
  end # Observer
end # Substation
