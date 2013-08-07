# encoding: utf-8

require 'pp'

require 'anima'
require 'ducktrap'
require 'vanguard'
require 'substation'

class Demo

  Undefined = Object.new.freeze

  require 'demo/domain/storage'
  require 'demo/domain/environment'
  require 'demo/domain/actor'
  require 'demo/domain/dto/person'

  DATABASE =
  {
    :privileges => [
      { :name => 'create_person' }
    ],

    :accounts => [
      { :id => 1, :name => 'Jane' },
      { :id => 2, :name => 'Mr.X' }
    ],

    :account_privileges => [
      { :account_id => 1, :privilege_name => 'create_person' }
    ],
  }

  logger   = Object.new # some logger instance
  storage  = Domain::Storage.new(DATABASE)
  env_name = ::ENV.fetch('APP_ENV', :development)

  APP_ENV = Domain::Environment.build(env_name, storage, logger)

  require 'demo/core/errors'
  require 'demo/core/input'
  require 'demo/core/handler'
  require 'demo/core/handler/authenticator'
  require 'demo/core/handler/authorizer'
  require 'demo/core/handler/acceptor'
  require 'demo/core/validator'
  require 'demo/core/action'
  require 'demo/core/action/create_person'
  require 'demo/core/observers'

  module Core
    ENV = Substation::Environment.build(APP_ENV) do
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
