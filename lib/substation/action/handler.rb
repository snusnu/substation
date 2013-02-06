module Substation
  class Action

    class Handler

      module NavigationSupport
        def on_success
          flash[:notice] = response.message
          move_to_view_for_success
        end

        def on_failure
          flash.now[:error] = response.message
          move_to_view_for_failure
        end

        def move_to_view_for_success
          redirect_to(view_for_success)
        end

        def move_to_view_for_failure
          render(view_for_failure)
        end
      end # module NavigationSupport

      class Index < Handler; end
      class Show  < Handler; end
      class New   < Handler; end
      class Edit  < Handler; end

      class Create < Handler
        module Navigation
          def view_for_success
            controller.send("#{success_handler.resource_name}_path")
          end

          def view_for_failure
            :new
          end

          def success_handler
            controller.class::Index
          end

          def failure_handler
            controller.class::New
          end
        end

        include NavigationSupport
        include Navigation
      end # class Create

      class Update < Handler
        module Navigation
          def view_for_success
            path_name = "edit_#{self.class.resource_name}_path"
            controller.send(path_name, resource)
          end

          def view_for_failure
            :edit
          end

          def success_handler
            controller.class::Edit
          end

          def failure_handler
            controller.class::Edit
          end
        end # module Navigation

        include NavigationSupport
        include Navigation
      end # class Update

      class Destroy < Handler
        module Navigation
          def view_for_success
            controller.send("#{success_handler.resource_name}_path")
          end

          def view_for_failure
            :edit
          end

          def success_handler
            controller.class::Index
          end

          def failure_handler
            controller.class::Edit
          end
        end # module Navigation

        include NavigationSupport
        include Navigation
      end # class Destroy

      def self.for(controller, namespace, action, method)
        handler = controller.class.const_get(class_name(method))
        handler.new(controller, namespace, action)
      end

      def self.install(controller, method, options)
        Installer.install(controller, method, options)
      end

      def self.class_name(method)
        Inflecto.camelize(method.to_s)
      end

      def self.controller=(controller)
        @controller = controller
      end

      def self.presenter=(presenter)
        @presenter = presenter
      end

      def self.presenter
        @presenter
      end

      # TODO refactor this
      def self.resource(name)
        @resource_name = name

        @controller.class_eval do
          attr_reader name.to_sym
          helper_attr name.to_sym
        end

        class_eval do
          # Make the resource available by name
          define_method name do
            resource
          end
        end

        self
      end

      def self.resource_name
        @resource_name
      end

      attr_reader :response

      extend Forwardable

      def_delegator :response,   :actor

      def_delegator :controller, :redirect_to
      def_delegator :controller, :render
      def_delegator :controller, :params
      def_delegator :controller, :session
      def_delegator :controller, :_session
      def_delegator :controller, :flash

      def initialize(controller, namespace, action)
        @controller = controller
        @namespace  = namespace
        @action     = action
      end

      def handle
        # this must be done first
        @controller.current_handler = self

        @response      = invoke_action
        @response.data = response_data
        set_resource_instance_variable(@response.data)
        @response.success? ? on_success : on_failure
        self
      end

      private

      attr_reader  :controller
      alias_method :c, :controller

      def on_success
        render
        self
      end

      def on_failure
        redirect_to '/error'
        self
      end

      def resource
        controller.send(self.class.resource_name)
      end

      def wrap_with_presenter(response)
        presenter(response.data)
      end

      def presenter(data)
        presenter_class.new(data)
      end

      def presenter_class
        SafePro::Presenters.const_get(presenter_class_name)
      end

      def has_presenter?
        ! self.class.presenter.nil?
      end

      def response_data
        has_presenter? ? presenter(@response.data) : @response.data
      end

      def invoke_action
        @namespace.const_get(demodulized_action_name).call(_session, params)
      end

      def demodulized_action_name
        Inflecto.camelize(@action.to_s)
      end

      def presenter_class_name
        Inflecto.camelize(self.class.presenter.to_s)
      end

      def set_resource_instance_variable(value)
        controller.instance_variable_set("@#{self.class.resource_name}", value)
      end
    end # class Handler
  end # class Action
end # module Substation
