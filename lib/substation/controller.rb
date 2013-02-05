module Substation

  module Controller

    def self.extended(host)
      host.class_eval { include Behavior }
    end

    def inherited(descendant)
      super
      descendant.install_substation_action_module
      descendant.class_eval { include substation_action_module }
    end

    # Provide a namespace for all generated action methods
    # Allows calling #super from overwritten action methods
    def install_substation_action_module
      @substation_action_module = const_set(:SubstationActions, Module.new)
    end

    # Namespace for all generated action methods
    def substation_action_module
      @substation_action_module
    end

    private

    def handle(namespace, map)
      map.each do |action_method, options|

        substation_action_module.module_eval do
          define_method action_method do
            handle(namespace, options.fetch(:with, action_method), options.fetch(:action, action_method))
          end
        end

        # Automatically define the desired handler class.
        # This provides the default behavior for the respective
        # action while still allowing to reopen the class and
        # customize the behavior.
        Action::Handler.install(self, action_method, options)
      end
    end

  end # module Controller
end # module Substation
