# encoding: utf-8

class Demo
  module Core

    class Action
      include AbstractType
      include Adamantium::Flat

      def self.call(request)
        new(request).call
      end

      private_class_method :new

      def initialize(request)
        @request = request
        @env     = @request.env
        @input   = @request.input
      end

      abstract_method :call

      private

      attr_reader :request
      attr_reader :env
      attr_reader :input

      def success(data)
        request.success(data)
      end

      def error(data)
        request.error(data)
      end

    end
  end
end
