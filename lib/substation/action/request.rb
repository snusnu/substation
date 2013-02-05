module Substation
  class Action

    class Request

      extend Forwardable

      attr_reader :action
      attr_reader :session
      attr_reader :params

      def_delegator :session, :actor
      def_delegator :session, :data, :session_data

      def initialize(action, session, params)
        @action  = action
        @session = session
        klass    = @action.params
        @params  = klass ? klass.new(params) : params
      end
    end # class Request
  end # class Action
end # module Substation
