# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '#dsl' do
  subject { dsl.new(processors, &block) }

  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class.new(registry) }
  let(:registry)   { { :test => Spec::Processor } }
  let(:processors) { [] }
  let(:block)      { ->(_) { test(Spec::FAKE_HANDLER, EMPTY_ARRAY) } }

  let(:processor)  { Spec::FAKE_PROCESSOR }

  it 'should register instantiated processors' do
    expect(subject.processors).to include(processor)
  end

  it 'should create a subclass of Chain::DSL' do
    expect(subject.class).to be < Chain::DSL
  end
end
