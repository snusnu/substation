# encoding: utf-8

class Demo
  module Core
    module Handler

      class Authenticator
        extend Handler
        include Substation::Processor::Evaluator::Handler

        def initialize(request)
          @request    = request
          @input      = @request.input
          @db         = @request.env.storage
          @account_id = @request.input.session.fetch('account_id')
        end

        def call
          authenticated? ? success(input) : error(input)
        end

        attr_reader :request
        private     :request

        attr_reader :input
        private     :input

        private

        def authenticated?
          !!@db.load_person(@account_id)
        end
      end
    end
  end
end
