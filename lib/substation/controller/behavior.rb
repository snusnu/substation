module Substation
  module Controller

    # This module expects to be included into a host
    # that returns true for #respond_to?(:session).
    # Mostly this will be a Rails ApplicationController
    module Behavior

      attr_accessor :current_handler

      def self.included(host)
        host.class_eval do
          helper_method :resource
        end
      end

      def action_response
        current_handler.response
      end

      def resource
        instance_variable_get("@#{current_handler.class.resource_name}")
      end

      def _session
        Substation::Session.new(current_actor, session)
      end

      private

      def handle(namespace, action, method)
        handler = Substation::Action::Handler::Installer.base_handler
        handler.for(self, namespace, action, method).handle
        self
      end

      def current_actor
        raise NotImplementedError, "#{self.class}##{__method__} must be implemented"
      end
    end # module Behavior
  end # module Controller
end # module Substation
