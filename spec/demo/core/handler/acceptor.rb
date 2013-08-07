# encoding: utf-8

class Demo
  module Core
    module Handler

      class Acceptor
        extend  Handler
        include Equalizer.new(:session)

        DECOMPOSER = ->(request) { request }

        COMPOSER = ->(request, output) {
          Input::Accepted.new(output, request.input.data)
        }

        EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

        def initialize(request)
          @db         = request.env.storage
          @session    = request.input.session
          @account_id = @session.fetch('account_id')
        end

        def call
          Domain::Actor.coerce(session, person)
        end

        attr_reader :session
        private     :session

        attr_reader :account_id
        private     :account_id

        private

        def person
          Domain::DTO::Person.new(:id => account_id, :name => name)
        end

        def name
          @db.load_person(account_id).name
        end
      end
    end
  end
end
