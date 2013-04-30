module Substation
  class Action

    # An action subclass that notifies observers
    class Observable < self

      # Call the action
      #
      # @see Action#call
      #
      # @return [Response]
      #
      # @api private
      def call
        response = super

        data = response.data

        if response.success?
          notify_success(data)
        else
          notify_failure(data)
        end

        response
      end

      private

      # Notify observers registered for a successful invocation
      #
      # @param [Object] data
      #   the response data returned from invoking the action
      #
      # @return [undefined]
      #
      # @api private
      def notify_success(data)
        notify(new_event(Event::Success, data))
      end

      # Notify observers registered for a failed invocation
      #
      # @param [Object] data
      #   the response data returned from invoking the action
      #
      # @return [undefined]
      #
      # @api private
      def notify_failure(data)
        notify(new_event(Event::Failure, data))
      end

      # Notify observers registered for the given kind of +event+
      #
      # @param [Event] event
      #   the event to notify observers about
      #
      # @return [undefined]
      #
      # @api private
      def notify(event)
        env.notify(event)
      end

      # Create a new instance of +event_class+
      #
      # @param [Class<Event>] event_class
      #   the class of the event to create
      #
      # @return [Event]
      #   a new instance of +event_class+
      #
      # @api private
      def new_event(event_class, data)
        event_class.new(self, DateTime.now, data)
      end

    end # module Instrumentation
  end # class Action
end # module Substation
