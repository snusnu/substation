# encoding: utf-8

class Demo
  module Web

    SANITIZATION_ERROR = Web::ENV.chain { wrap Error::SanitizationError }

    INTERNAL_ERROR = Web::ENV.chain(Core::App::INTERNAL_ERROR) do
      wrap Views::InternalError
    end

    CREATE_PERSON = Web::ENV.chain do
      deserialize Handler::Deserializer
      sanitize    Sanitizer::NEW_PERSON, SANITIZATION_ERROR
      chain       Core::App::CREATE_PERSON
    end

    module HTML

      SANITIZATION_ERROR = Web::ENV.chain(Web::SANITIZATION_ERROR) do
        wrap   Views::SanitizationError
        render Renderer::SanitizationError
      end

      AUTHENTICATION_ERROR = Web::ENV.chain(Core::App::AUTHENTICATION_ERROR) do
        render Renderer::AuthenticationError
      end

      AUTHORIZATION_ERROR = Web::ENV.chain(Core::App::AUTHORIZATION_ERROR) do
        render Renderer::AuthorizationError
      end

      VALIDATION_ERROR = Web::ENV.chain(Core::App::VALIDATION_ERROR) do
        render Renderer::ValidationError
      end

      APPLICATION_ERROR = Web::ENV.chain(Core::App::APPLICATION_ERROR) do
        render Renderer::ApplicationError
      end

      INTERNAL_ERROR  = Web::ENV.chain(Web::INTERNAL_ERROR) do
        render Renderer::InternalError
      end

      CREATE_PERSON = Web::ENV.chain(Web::CREATE_PERSON, INTERNAL_ERROR) do
        failure_chain :sanitize,     SANITIZATION_ERROR
        failure_chain :authenticate, AUTHENTICATION_ERROR
        failure_chain :authorize,    AUTHORIZATION_ERROR
        failure_chain :validate,     VALIDATION_ERROR
        failure_chain :call,         APPLICATION_ERROR
        wrap Presenter::Person
        wrap Views::Person
      end

      # The application
      APP = Web::ENV.dispatcher(APP_ENV) do
        dispatch :create_person, CREATE_PERSON
      end

    end # module HTML
  end # module Web
end # class Demo
