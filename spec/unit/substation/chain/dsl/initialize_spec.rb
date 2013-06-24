# encoding: utf-8

require 'spec_helper'

# Test wether env is correctly passed down
describe Chain::DSL, '#initialize' do
  subject { dsl.new(env, processors, &block) }

  let(:env)        { Spec::FAKE_ENV }
  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class::Builder.new(registry) }
  let(:registry)   { { :test => Spec::Processor } }
  let(:processors) { [] }
  let(:block)      { lambda { |_| test(Spec::FAKE_HANDLER) } }

  let(:processor)  { Spec::FAKE_PROCESSOR }

  its(:processors) { should include(processor) }
end
