# encoding: utf-8

class Demo
  module Core

    class Actor
      class Session
        include Equalizer.new(:data)

        attr_reader :account_id

        def initialize(data)
          @data       = data
          @account_id = @data.fetch('account_id')
        end

        protected

        attr_reader :data
      end

      def self.coerce(session_data, person)
        new(Session.new(session_data), person)
      end

      include Concord::Public.new(:session, :person)
    end
  end
end
