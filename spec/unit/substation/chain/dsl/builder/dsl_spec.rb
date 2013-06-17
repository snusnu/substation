# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '#dsl' do
  subject { dsl.new(processors, &block) }

  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class.new(registry) }
  let(:registry)   { { :test => Spec::Processor } }
  let(:processors) { [] }
  let(:block)      { lambda { |_| test(Spec::FAKE_HANDLER) } }
  let(:processor)  { Spec::Processor.new(Spec::FAKE_HANDLER) }

  it { should be_a(Chain::DSL) }

  its(:processors) { should include(processor) }
end
