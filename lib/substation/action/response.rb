module Substation
  class Action

    class Response

      extend Forwardable

      attr_reader :request

      def_delegator :request, :action
      def_delegator :request, :actor

      attr_accessor :data
      attr_accessor :exception
      attr_accessor :message

      def initialize(request)
        @request = request
      end

      def success?
        exception.nil?
      end
    end # class Response
  end # class Action
end # module Substation
