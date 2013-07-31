# encoding: utf-8

class Demo

  module Core

    CREATE_PERSON = Core::ENV.action Action::CreatePerson, [
      Observers::LOG_EVENT,
      Observers::SEND_EMAIL
    ]

    module App

      AUTHENTICATION_ERROR = Core::ENV.chain { wrap Error::AuthenticationError }
      AUTHORIZATION_ERROR  = Core::ENV.chain { wrap Error::AuthorizationError }
      VALIDATION_ERROR     = Core::ENV.chain { wrap Error::ValidationError }
      APPLICATION_ERROR    = Core::ENV.chain { wrap Error::ApplicationError }
      INTERNAL_ERROR       = Core::ENV.chain { wrap Error::InternalError }

      AUTHENTICATE = Core::ENV.chain do
        authenticate Handler::Authenticator, AUTHENTICATION_ERROR
      end

      AUTHORIZE = Core::ENV.chain(AUTHENTICATE) do
        authorize Handler::Authorizer, AUTHORIZATION_ERROR
      end

      Core::ENV.register(:create_person, AUTHORIZE, INTERNAL_ERROR) do
        validate Domain::DTO::NEW_PERSON_VALIDATOR, VALIDATION_ERROR
        accept   Handler::Acceptor
        call     Core::CREATE_PERSON, APPLICATION_ERROR
      end

    end

    # The application
    APP = Core::ENV.dispatcher

  end
end
