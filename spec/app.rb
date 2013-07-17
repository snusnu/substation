# encoding: utf-8

require 'pp'

require 'multi_json'
require 'anima'
require 'ducktrap'
require 'vanguard'
require 'substation'

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

  class Input
    class Incomplete
      include Concord::Public.new(:session, :data)
    end
    class Accepted
      include Concord::Public.new(:actor, :data)
    end
  end

  class Actor
    class Session
      include Equalizer.new(:data)

      attr_reader :account_id

      def initialize(data)
        @data       = data
        @account_id = @data.fetch('account_id')
      end

      protected

      attr_reader :data
    end

    def self.coerce(session_data, person)
      new(Session.new(session_data), person)
    end

    include Concord::Public.new(:session, :person)
  end

  ACCOUNTS = {
    1 => { :name => 'Jane', :privileges => [ :create_person ] },
    2 => { :name => 'Mr.X', :privileges => [] }
  }

  module Handler

    include Adamantium::Flat

    def call(request)
      new(request).call
    end

    module Wrapper
      module Outgoing
        DECOMPOSER = ->(response) { response.data }
        COMPOSER   = ->(response, output) { output }
        EXECUTOR   = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)
      end
    end

    class Deserializer
      extend  Handler
      include Concord.new(:input)

      DECOMPOSER = ->(request) {
        request.input
      }

      COMPOSER = ->(request, output) {
        Input::Incomplete.new(output.fetch('session'), output.fetch('data'))
      }

      EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      def call
        {
          'session' => deserialize(input.fetch('session')),
          'data'    => deserialize(input.fetch('data'))
        }
      end

      private

      def deserialize(json)
        MultiJson.load(json)
      end
    end

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

    class Acceptor
      extend  Handler
      include Equalizer.new(:session)

      DECOMPOSER = ->(request) {
        request.input.session
      }

      COMPOSER = ->(request, output) {
        Input::Accepted.new(output, request.input.data)
      }

      EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

      def initialize(session)
        @session    = session
        @account_id = @session.fetch('account_id')
      end

      def call
        Actor.coerce(session, person)
      end

      private

      attr_reader :session
      attr_reader :account_id

      def person
        Models::Person.new(:id => account_id, :name => name)
      end

      def name
        Demo::ACCOUNTS.fetch(account_id)[:name]
      end
    end
  end

  module Models
    class Person
      include Anima.new(:id, :name)
    end
  end

  module Sanitizer

    # substation support

    DECOMPOSER = ->(request) {
      request.input.data
    }

    COMPOSER = ->(request, output) {
      Input::Incomplete.new(request.input.session, output)
    }

    EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

    # sanitizers

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

  module Validator

    # substation support

    DECOMPOSER = ->(request) {
      request.input.data
    }

    COMPOSER = ->(request, output) {
      Input::Incomplete.new(request.input.session, output)
    }

    EXECUTOR = Substation::Processor::Executor.new(DECOMPOSER, COMPOSER)

    # validators

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
        @person = input.data
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
    register :deserialize,  Substation::Processor::Transformer::Incoming, Handler::Deserializer::EXECUTOR
    register :sanitize,     Substation::Processor::Evaluator::Request, Sanitizer::EXECUTOR
    register :authenticate, Substation::Processor::Evaluator::Request
    register :authorize,    Substation::Processor::Evaluator::Request
    register :validate,     Substation::Processor::Evaluator::Request, Validator::EXECUTOR
    register :accept,       Substation::Processor::Transformer::Incoming, Handler::Acceptor::EXECUTOR
    register :call,         Substation::Processor::Evaluator::Pivot
    register :wrap,         Substation::Processor::Wrapper::Outgoing, Handler::Wrapper::Outgoing::EXECUTOR
    register :render,       Substation::Processor::Transformer::Outgoing
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
      validate Validator::NEW_PERSON, VALIDATION_ERROR
      accept   Handler::Acceptor
      call     Demo::CREATE_PERSON, APPLICATION_ERROR
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
      deserialize Handler::Deserializer
      sanitize    Sanitizer::NEW_PERSON, SANITIZATION_ERROR
      chain       App::CREATE_PERSON
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
