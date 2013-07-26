# encoding: utf-8

module Substation

  # Encapsulates access to an observable handler
  class Action

    include Concord.new(:handler, :observers)
    include Adamantium::Flat

    # Call the action
    #
    # @param [Substation::Request] request
    #   the request passed to the registered action
    #
    # @return [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def call(request)
      notify_observers(handler.call(request))
    end

    private

    # Notify all observers
    #
    # @param [Response] response
    #   the response returned from {handler#call}
    #
    # @return [undefined]
    #
    # @api private
    def notify_observers(response)
      observers.each { |observer| observer.call(response) }
      response
    end

  end # class Action
end # module Substation
