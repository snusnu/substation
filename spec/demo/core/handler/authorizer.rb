# encoding: utf-8

class Demo
  module Core
    module Handler

      class Authorizer
        extend Handler

        def initialize(request)
          @request    = request
          @input      = @request.input
          @account_id = @request.input.session.fetch('account_id')
          @privilege  = @request.name
        end

        def call
          authorized? ? request.success(input) : request.error(input)
        end

        private

        attr_reader :request
        attr_reader :input

        def authorized?
          Demo::ACCOUNTS.fetch(@account_id)[:privileges].include?(@privilege)
        end
      end

    end
  end
end
