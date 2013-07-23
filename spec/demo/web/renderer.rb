# encoding: utf-8

class Demo
  module Web

    module Renderer

      class SanitizationError
        def self.call(response)
          "Don't mess with the input params: #{response.input.data.inspect}"
        end
      end

      class AuthenticationError
        def self.call(response)
          "Failed to authenticate: #{response.input.data.inspect}"
        end
      end

      class AuthorizationError
        def self.call(response)
          "Failed to authorize: #{response.input.data.inspect}"
        end
      end

      class ValidationError
        def self.call(response)
          "Failed to validate: #{response.input.data.inspect}"
        end
      end

      class ApplicationError
        def self.call(response)
          "Failed to process: #{response.output.inspect}"
        end
      end

      class InternalError
        def self.call(response)
          "Something bad happened: #{response.output.inspect}"
        end
      end
    end
  end
end
