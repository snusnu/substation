# encoding: utf-8

class Demo
  module Core
    module Handler

      class Acceptor
        extend  Handler
        include Equalizer.new(:session)

        DECOMPOSER = ->(request) {
          request.input.session
        }

        COMPOSER = ->(request, output) {
          Input::Accepted.new(output, request.input.data)
        }

        EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

        def initialize(session)
          @session    = session
          @account_id = @session.fetch('account_id')
        end

        def call
          Domain::Actor.coerce(session, person)
        end

        private

        attr_reader :session
        attr_reader :account_id

        def person
          Domain::DTO::Person.new(:id => account_id, :name => name)
        end

        def name
          Demo::ACCOUNTS.fetch(account_id)[:name]
        end
      end
    end
  end
end
