# encoding: utf-8

class Demo
  module Core
    module Handler

      class Authorizer
        extend Handler
        include Substation::Processor::Evaluator::Handler

        def initialize(request)
          @request    = request
          @input      = @request.input
          @db         = @request.env.storage
          @account_id = @request.input.session.fetch('account_id')
          @privilege  = @request.name.to_s
        end

        def call
          authorized? ? success(input) : error(input)
        end

        attr_reader :request
        private     :request

        attr_reader :input
        private     :input

        private

        def authorized?
          !!@db.load_account_privilege(@account_id, @privilege)
        end
      end

    end
  end
end
