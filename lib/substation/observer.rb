module Substation
  # Abstract observer base class
  class Observer 
    include AbstractType
    include Adamantium::Flat

    # Notify observer
    #
    # @param [Action::Response] response
    #
    # @return [self]
    #
    # @api private
    #
    abstract_method :call

    # Coerce input to observer
    #
    # @param [NilClass|String|Array<String>] input
    #
    # @return [Observer]
    #
    # @api private
    #
    def self.coerce(input)
      case input
      when NilClass
        NOOP
      when String
        Utils.const_get(input)
      when Array
        Chain.new(input.map { |item| coerce(item) })
      else
        raise ArgumentError, "Uncoercible input: #{input.inspect}"
      end
    end

    # Noop observer
    class NOOP < self
      private_class_method :new

      # Notify observer
      #
      # @param [Action::Response] response
      #
      # @return [self]
      #
      # @api private
      #
      def self.call(_response)
        self
      end

    end

    # Chain of observers
    class Chain < self
      include Concord.new(:observers)

      # Notify observer
      #
      # @param [Action::Response] response
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
