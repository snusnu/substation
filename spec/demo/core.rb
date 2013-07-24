# encoding: utf-8

require 'pp'

require 'anima'
require 'ducktrap'
require 'vanguard'
require 'substation'

class Demo

  Undefined = Object.new.freeze

  ACCOUNTS = {
    1 => { :name => 'Jane', :privileges => [ :create_person ] },
    2 => { :name => 'Mr.X', :privileges => [] }
  }

  logger   = Object.new # some logger instance
  storage  = Object.new # some database abstraction e.g. ROM::Environment
  env_name = ::ENV.fetch('APP_ENV', :development)

  require 'demo/environment'

  APP_ENV = Environment.build(env_name, storage, logger)

  require 'demo/core/models/person'
  require 'demo/core/errors'
  require 'demo/core/input'
  require 'demo/core/actor'
  require 'demo/core/handler'
  require 'demo/core/handler/authenticator'
  require 'demo/core/handler/authorizer'
  require 'demo/core/handler/acceptor'
  require 'demo/core/validator'
  require 'demo/core/validator/person'
  require 'demo/core/action'
  require 'demo/core/action/create_person'
  require 'demo/core/observers'

  module Core
    ENV = Substation::Environment.build do
      register :authenticate, Substation::Processor::Evaluator::Request
      register :authorize,    Substation::Processor::Evaluator::Request
      register :validate,     Substation::Processor::Evaluator::Request, Core::Validator::EXECUTOR
      register :accept,       Substation::Processor::Transformer::Incoming, Core::Handler::Acceptor::EXECUTOR
      register :call,         Substation::Processor::Evaluator::Pivot
      register :wrap,         Substation::Processor::Wrapper::Outgoing, Core::Handler::Wrapper::Outgoing::EXECUTOR
    end
  end

  require 'demo/core/facade'
end
