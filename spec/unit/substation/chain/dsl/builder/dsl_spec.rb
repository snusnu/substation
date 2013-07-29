# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::Builder, '#dsl' do
  subject { dsl.new(definition, &block) }

  let(:dsl)        { builder.dsl }
  let(:builder)    { described_class.new(registry) }
  let(:registry)   { { name => processor_builder } }
  let(:name)       { :test }
  let(:definition) { Chain::Definition.new }

  let(:processor)         { processor_builder.call(Spec::FAKE_HANDLER, Chain::EMPTY) }
  let(:processor_builder) { Processor::Builder.new(name, Spec::Processor, Processor::Executor::NULL) }

  shared_examples_for 'Chain::DSL::Builder#dsl' do
    it 'should register instantiated processors' do
      expect(subject.definition).to include(processor)
    end

    it 'should create a subclass of Chain::DSL' do
      expect(subject.class).to be < Chain::DSL
    end
  end

  context 'when a failure chain was specified' do
    let(:block) { ->(_) { test(Spec::FAKE_HANDLER, Chain::EMPTY) } }

    it_behaves_like 'Chain::DSL::Builder#dsl'
  end

  context 'when no failure chain was specified' do
    let(:block) { ->(_) { test(Spec::FAKE_HANDLER) } }

    it_behaves_like 'Chain::DSL::Builder#dsl'
  end
end
