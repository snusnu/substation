# encoding: utf-8

class Demo
  module Core

    module App

      AUTHENTICATION_ERROR = Core::ENV.chain { wrap Error::AuthenticationError }
      AUTHORIZATION_ERROR  = Core::ENV.chain { wrap Error::AuthorizationError }
      VALIDATION_ERROR     = Core::ENV.chain { wrap Error::ValidationError }
      APPLICATION_ERROR    = Core::ENV.chain { wrap Error::ApplicationError }
      INTERNAL_ERROR       = Core::ENV.chain { wrap Error::InternalError }

      AUTHENTICATE = Core::ENV.chain do
        authenticate Handler::Authenticator, AUTHENTICATION_ERROR
      end

      AUTHORIZE = Core::ENV.chain(nil, AUTHENTICATE) do
        authorize Handler::Authorizer, AUTHORIZATION_ERROR
      end

      Core::ENV.register(:create_person, AUTHORIZE, INTERNAL_ERROR) do
        validate Domain::DTO::NEW_PERSON_VALIDATOR, VALIDATION_ERROR
        accept   Handler::Acceptor

        call Action::CreatePerson, APPLICATION_ERROR, [
          Observers::LOG_EVENT,
          Observers::SEND_EMAIL
        ]
      end

    end

    # The application
    APP = Core::ENV.dispatcher

  end
end
