# encoding: utf-8

class Demo
  module Core
    module Handler

      class Authenticator
        extend Handler

        def initialize(request)
          @request    = request
          @input      = @request.input
          @account_id = @request.input.session.fetch('account_id')
        end

        def call
          authenticated? ? request.success(input) : request.error(input)
        end

        private

        attr_reader :request
        attr_reader :input

        def authenticated?
          Demo::ACCOUNTS.include?(@account_id)
        end
      end
    end
  end
end
