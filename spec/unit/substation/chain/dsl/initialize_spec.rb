# encoding: utf-8

require 'spec_helper'

# Test wether env is correctly passed down
describe Chain::DSL, '#initialize' do
  subject { dsl.new(env, processors, &block) }

  let(:env)        { mock(:failure_chain => mock) }
  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class::Builder.new(registry) }
  let(:registry)   { { :test => Spec::Processor } }
  let(:processors) { [] }
  let(:block)      { lambda { |_| test(Spec::FAKE_HANDLER) } }

  let(:processor)  { Spec::Processor.new(env.failure_chain, Spec::FAKE_HANDLER) }

  its(:processors) { should include(processor) }
end
