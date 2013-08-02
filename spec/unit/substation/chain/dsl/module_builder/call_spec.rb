# encoding: utf-8

require 'spec_helper'

describe Chain::DSL::ModuleBuilder, '#dsl_module' do
  subject { object.dsl_module }

  let(:object)            { described_class.new(registry) }
  let(:registry)          { { :test => processor_builder } }
  let(:processor_builder) { double('processor_builder') }
  let(:handler)           { double('handler') }
  let(:failure_chain)     { double('failure_chain') }

  let(:definition)  { Chain::Definition.new(processors) }
  let(:processors)  { [processor_1] }
  let(:processor_1) { double('processor_1') }
  let(:processor_2) { double('processor_2') }

  before do
    expect(processor_builder)
      .to receive(:call)
      .with(handler, failure_chain)
      .and_return(processor_2)
  end

  shared_examples_for 'Chain::DSL::ModuleBuilder#dsl_module' do
    it 'compiles appropriate methods' do
      config = Chain::DSL::Config.new(registry, subject)
      dsl    = Chain::DSL.new(config, definition)

      dsl.test(*dsl_method_args)

      expect(dsl.definition).to include(processor_1)
      expect(dsl.definition).to include(processor_2)
    end
  end

  context 'when a failure_chain is given' do
    let(:dsl_method_args) { [handler, failure_chain] }

    it_behaves_like 'Chain::DSL::ModuleBuilder#dsl_module'
  end

  context 'when no failure_chain is given' do
    let(:dsl_method_args) { [handler] }
    let(:failure_chain)   { Chain::EMPTY }

    it_behaves_like 'Chain::DSL::ModuleBuilder#dsl_module'
  end
end
