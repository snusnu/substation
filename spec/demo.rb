# encoding: utf-8

require 'demo/web'

class Demo

  # TODO: support building on top of existing environments
  ENV = Substation::Environment.build do
    register :deserialize,  Substation::Processor::Transformer::Incoming, Web::Handler::Deserializer::EXECUTOR
    register :sanitize,     Substation::Processor::Evaluator::Request, Web::Sanitizer::EXECUTOR
    register :authenticate, Substation::Processor::Evaluator::Request
    register :authorize,    Substation::Processor::Evaluator::Request
    register :validate,     Substation::Processor::Evaluator::Request, Core::Validator::EXECUTOR
    register :accept,       Substation::Processor::Transformer::Incoming, Core::Handler::Acceptor::EXECUTOR
    register :call,         Substation::Processor::Evaluator::Pivot
    register :wrap,         Substation::Processor::Wrapper::Outgoing, Core::Handler::Wrapper::Outgoing::EXECUTOR
    register :render,       Substation::Processor::Transformer::Outgoing
  end

  logger   = Object.new # some logger instance
  storage  = Object.new # some database abstraction e.g. ROM::Environment
  env_name = ::ENV.fetch('APP_ENV', :development)

  APP_ENV = Environment.build(env_name, storage, logger)

end

require 'demo/core/facade'
require 'demo/web/facade'
