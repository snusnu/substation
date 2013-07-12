# encoding: utf-8

require 'pp'

require 'substation'
require 'anima'
require 'ducktrap'
require 'vanguard'

class Demo

  Undefined = Object.new.freeze

  class Environment

    def self.build(name, storage, logger)
      coerced_name = name.to_sym
      klass = case coerced_name
      when :development
        Development
      when :test
        Test
      when :production
        Production
      end
      klass.new(coerced_name, storage, logger)
    end

    class Development < self
      def development?
        true
      end
    end

    class Test < self
      def test?
        true
      end
    end

    class Production < self
      def production?
        true
      end
    end

    include AbstractType
    include Concord.new(:name, :storage, :logger)

    def development?
      false
    end

    def test?
      false
    end

    def production?
      false
    end
  end

  module Handler

    def call(request)
      new(request).call
    end

    class Authenticator
      extend Handler
      include Substation::Processor::Evaluator::Handler
      include Concord.new(:request)

      def call
        if request.input.name != 'unknown'
          success(request.input)
        else
          error(request.input)
        end
      end
    end

    class Authorizer
      extend Handler
      include Substation::Processor::Evaluator::Handler
      include Concord.new(:request)

      def call
        if request.input.name != 'forbidden'
          success(request.input)
        else
          error(request.input)
        end
      end
    end

  end

  module Models
    class Person
      include Anima.new(:id, :name)
    end
  end

  module Sanitizers
    ID_TRAP = Ducktrap.build do
      custom do
        forward { |input| input.merge(:id => nil) }
        inverse { |input|
          input = input.dup
          input.delete(:id)
          input
        }
      end
    end

    NEW_PERSON = Ducktrap.build do
      primitive(Hash)
      hash_transform do
        fetch_key('name') do
          primitive(String)
          dump_key(:name)
        end
      end
      add(ID_TRAP)
      anima_load(Models::Person)
    end
  end

  module Validators
    NEW_PERSON = Vanguard::Validator.build do
      validates_presence_of :name
      validates_length_of :name, :length => 3..20
    end
  end

  class Action
    include AbstractType
    include Adamantium::Flat

    def self.call(request)
      new(request).call
    end

    private_class_method :new

    def initialize(request)
      @request = request
      @env     = @request.env
      @input   = @request.input
    end

    abstract_method :call

    private

    attr_reader :request
    attr_reader :env
    attr_reader :input

    def success(data)
      request.success(data)
    end

    def error(data)
      request.error(data)
    end

    class CreatePerson < self
      def initialize(*)
        super
        @person = input
      end

      def call
        name = @person.name
        if name == 'error'
          error(@person)
        elsif name == 'exception'
          raise RuntimeError
        else
          success(@person)
        end
      end
    end
  end

  module Observers
    LOG_EVENT  = ->(response) { }
    SEND_EMAIL = ->(response) { }
  end

  class Presenter
    include AbstractType
    include Adamantium::Flat
    include Concord.new(:data)

    def method_missing(method, *args, &block)
      @data.send(method, *args, &block)
    end

    def respond_to?(method)
      super || @data.respond_to?(method)
    end

    class Collection < self

      def self.member(presenter = Undefined)
        return @member if presenter.equal?(Undefined)
        @member = presenter
      end

      alias_method :entries, :data

      protected :entries

      def each
        return to_enum unless block_given?
        entries.each { |entry| yield self.class.member.new(entry) }
        self
      end
    end
  end

  module Presenters

    class Person < Presenter

      def name
        "Presenting: #{super}"
      end

      class Collection < Presenter::Collection
        member(Person)
      end
    end
  end

  module Views

    module Layout
      def page_title
        'substation demo'
      end
    end

    class Person < Presenter
      include Layout
    end

    class SanitizationError
      include Concord::Public.new(:error)
      include Layout
    end

    class InternalError
      include Concord::Public.new(:data)
    end
  end

  module Renderer

    class SanitizationError
      def self.call(response)
        "Don't mess with the input params: #{response.input.inspect}"
      end
    end

    class AuthenticationError
      def self.call(response)
        "Failed to authenticate: #{response.input.inspect}"
      end
    end

    class AuthorizationError
      def self.call(response)
        "Failed to authorize: #{response.input.inspect}"
      end
    end

    class ValidationError
      def self.call(response)
        "Failed to validate: #{response.input.inspect}"
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

  class Error
    include Concord::Public.new(:object)
    include Adamantium::Flat

    InternalError       = Class.new(self)
    ApplicationError    = Class.new(self)
    SanitizationError   = Class.new(self)
    AuthenticationError = Class.new(self)
    AuthorizationError  = Class.new(self)
    ValidationError     = Class.new(self)
  end

  ENV = Substation::Environment.build do
    register :sanitize,     Substation::Processor::Evaluator::Data
    register :authenticate, Substation::Processor::Evaluator::Request
    register :authorize,    Substation::Processor::Evaluator::Request
    register :validate,     Substation::Processor::Evaluator::Data
    register :call,         Substation::Processor::Evaluator::Pivot
    register :wrap,         Substation::Processor::Wrapper
    register :render,       Substation::Processor::Transformer
  end

  CREATE_PERSON = ENV.action Action::CreatePerson, [
    Observers::LOG_EVENT,
    Observers::SEND_EMAIL
  ]

  module App

    AUTHENTICATION_ERROR = Demo::ENV.chain { wrap Error::AuthenticationError }
    AUTHORIZATION_ERROR  = Demo::ENV.chain { wrap Error::AuthorizationError }
    VALIDATION_ERROR     = Demo::ENV.chain { wrap Error::ValidationError }
    APPLICATION_ERROR    = Demo::ENV.chain { wrap Error::ApplicationError }
    INTERNAL_ERROR       = Demo::ENV.chain { wrap Error::InternalError }

    AUTHENTICATE = ENV.chain do
      authenticate Handler::Authenticator, AUTHENTICATION_ERROR
    end

    AUTHORIZE = ENV.chain(AUTHENTICATE) do
      authorize Handler::Authorizer, AUTHORIZATION_ERROR
    end

    CREATE_PERSON = ENV.chain(AUTHORIZE) do
      validate Validators::NEW_PERSON, VALIDATION_ERROR
      call Demo::CREATE_PERSON, APPLICATION_ERROR
    end

  end

  logger   = Object.new # some logger instance
  storage  = Object.new # some database abstraction e.g. ROM::Environment
  env_name = ::ENV.fetch('APP_ENV', :development)
  APP_ENV  = Environment.build(env_name, storage, logger)

  module Web

    SANITIZATION_ERROR = Demo::ENV.chain { wrap Error::SanitizationError }

    INTERNAL_ERROR = Demo::ENV.chain(App::INTERNAL_ERROR) do
      wrap Views::InternalError
    end

    CREATE_PERSON = Demo::ENV.chain do
      sanitize Sanitizers::NEW_PERSON, SANITIZATION_ERROR
      chain App::CREATE_PERSON
    end

    module HTML

      SANITIZATION_ERROR = Demo::ENV.chain(Web::SANITIZATION_ERROR) do
        wrap   Views::SanitizationError
        render Renderer::SanitizationError
      end

      AUTHENTICATION_ERROR = Demo::ENV.chain(App::AUTHENTICATION_ERROR) do
        render Renderer::AuthenticationError
      end

      AUTHORIZATION_ERROR = Demo::ENV.chain(App::AUTHORIZATION_ERROR) do
        render Renderer::AuthorizationError
      end

      VALIDATION_ERROR = Demo::ENV.chain(App::VALIDATION_ERROR) do
        render Renderer::ValidationError
      end

      APPLICATION_ERROR = Demo::ENV.chain(App::APPLICATION_ERROR) do
        render Renderer::ApplicationError
      end

      INTERNAL_ERROR  = Demo::ENV.chain(Web::INTERNAL_ERROR) do
        render Renderer::InternalError
      end

      CREATE_PERSON = Demo::ENV.chain(Web::CREATE_PERSON, INTERNAL_ERROR) do
        failure_chain :sanitize,     SANITIZATION_ERROR
        failure_chain :authenticate, AUTHENTICATION_ERROR
        failure_chain :authorize,    AUTHORIZATION_ERROR
        failure_chain :validate,     VALIDATION_ERROR
        failure_chain :call,         APPLICATION_ERROR
        wrap Presenters::Person
        wrap Views::Person
      end

      # The application
      APP = Demo::ENV.dispatcher(APP_ENV) do
        dispatch :create_person, CREATE_PERSON
      end

    end # module HTML

  end # module Web
end # class Demo
