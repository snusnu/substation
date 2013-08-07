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
        @db      = @env.storage
      end

      abstract_method :call

      attr_reader :request
      private     :request

      attr_reader :env
      private     :env

      attr_reader :input
      private     :input

      attr_reader :db
      private     :db

      private

      def success(data)
        request.success(data)
      end

      def error(data)
        request.error(data)
      end

    end
  end
end
