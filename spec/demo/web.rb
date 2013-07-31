# encoding: utf-8

require 'multi_json'

require 'demo/core'

require 'demo/web/errors'
require 'demo/web/handler/deserializer'
require 'demo/web/sanitizer'
require 'demo/web/sanitizer/person'
require 'demo/web/presenter'
require 'demo/web/presenter/person'
require 'demo/web/views'
require 'demo/web/renderer'

class Demo
  module Web
    ENV = Substation::Environment.inherit(Core::ENV) do
      register :deserialize, Substation::Processor::Transformer::Incoming, Web::Handler::Deserializer::EXECUTOR
      register :sanitize,    Substation::Processor::Evaluator::Request, Web::Sanitizer::EXECUTOR
      register :wrap,        Substation::Processor::Wrapper::Outgoing, Core::Handler::Wrapper::Outgoing::EXECUTOR
      register :render,      Substation::Processor::Transformer::Outgoing
    end
  end
end

require 'demo/web/facade'
