# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#build' do
  include_context 'Chain::DSL#initialize'

  let(:failure_chain)       { Chain::EMPTY }
  let(:block)               { ->(_) { test(Spec::FAKE_HANDLER) } }
  let(:expected_definition) { Chain::Definition.new(chain_name, expected_processors) }
  let(:expected)            { Chain.new(expected_definition, failure_chain) }

  let(:new_processors)      { [new_processor] }
  let(:new_processor)       { double('new_processor', :name => :new_processor) }

  shared_examples_for 'duplicate processors' do
    let(:new_processor) { processor }
    let(:msg)           { Chain::Definition::DUPLICATE_PROCESSOR_MSG % [processor].inspect }

    it 'should raise DuplicateProcessorError' do
      expect { subject }.to raise_error(DuplicateProcessorError, msg)
    end
  end

  shared_examples_for 'disjoint processors' do
    it { should eql(expected) }

    it 'injects the proper registry' do
      expect(chain_dsl.registry).to be(registry)
    end
  end

  context 'when a block is given' do
    subject { chain_dsl.build(chain_name, new_processors, failure_chain, &block) }

    context 'and all processors are disjoint' do
      let(:expected_processors) { [processor, new_processor, Spec::FAKE_PROCESSOR] }

      it_behaves_like 'disjoint processors'
    end

    context 'and there are duplicate processors' do
      it_behaves_like 'duplicate processors'
    end
  end

  context 'when no block is given' do
    subject { chain_dsl.build(chain_name, new_processors, failure_chain) }

    context 'and all processors are disjoint' do
      let(:expected_processors) { [processor, new_processor] }

      it_behaves_like 'disjoint processors'
    end

    context 'and there are duplicate processors' do
      it_behaves_like 'duplicate processors'
    end
  end
end
