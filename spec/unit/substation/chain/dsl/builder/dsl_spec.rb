# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '#dsl' do
  subject { dsl.new(processors, &block) }

  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class.new(registry) }
  let(:registry)   { { name => processor_builder } }
  let(:name)       { :test }
  let(:processors) { [] }
  let(:block)      { ->(_) { test(Spec::FAKE_HANDLER, Chain::EMPTY) } }

  let(:processor)         { processor_builder.call(Spec::FAKE_HANDLER, Chain::EMPTY) }
  let(:processor_builder) { Processor::Builder.new(name, Spec::Processor, Processor::Executor::NULL) }

  it 'should register instantiated processors' do
    expect(subject.processors).to include(processor)
  end

  it 'should create a subclass of Chain::DSL' do
    expect(subject.class).to be < Chain::DSL
  end
end
