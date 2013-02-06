module Substation
  class Action

    class Request

      extend Forwardable

      def self.new(action, session, params)
        params_class    = action.params
        params_instance = params_class ? params_class.new(params) : params
        super(action, session, params_instance)
      end

      attr_reader :action
      attr_reader :session
      attr_reader :params

      def_delegator :session, :actor
      def_delegator :session, :data, :session_data

      def initialize(action, session, params)
        @action  = action
        @session = session
        @params  = params
      end
    end # class Request
  end # class Action
end # module Substation
