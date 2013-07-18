# encoding: utf-8

class Demo

  module Core

    CREATE_PERSON = Demo::ENV.action Action::CreatePerson, [
      Observers::LOG_EVENT,
      Observers::SEND_EMAIL
    ]

    module App

      AUTHENTICATION_ERROR = Demo::ENV.chain { wrap Error::AuthenticationError }
      AUTHORIZATION_ERROR  = Demo::ENV.chain { wrap Error::AuthorizationError }
      VALIDATION_ERROR     = Demo::ENV.chain { wrap Error::ValidationError }
      APPLICATION_ERROR    = Demo::ENV.chain { wrap Error::ApplicationError }
      INTERNAL_ERROR       = Demo::ENV.chain { wrap Error::InternalError }

      AUTHENTICATE = Demo::ENV.chain do
        authenticate Handler::Authenticator, AUTHENTICATION_ERROR
      end

      AUTHORIZE = Demo::ENV.chain(AUTHENTICATE) do
        authorize Handler::Authorizer, AUTHORIZATION_ERROR
      end

      CREATE_PERSON = Demo::ENV.chain(AUTHORIZE) do
        validate Validator::NEW_PERSON, VALIDATION_ERROR
        accept   Handler::Acceptor
        call     Core::CREATE_PERSON, APPLICATION_ERROR
      end

    end
  end
end
