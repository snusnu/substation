# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#build' do
  include_context 'Chain::DSL#initialize'

  let(:failure_chain)       { Chain::EMPTY }
  let(:block)               { ->(_) { test(Spec::FAKE_HANDLER) } }
  let(:expected_definition) { Chain::Definition.new(expected_processors) }
  let(:expected)            { Chain.new(expected_definition, failure_chain) }

  context 'when a block is given' do
    subject { chain_dsl.build(processors, failure_chain, &block) }

    let(:expected_processors) { [processor, processor, Spec::FAKE_PROCESSOR] }

    it { should eql(expected) }

    it 'injects the proper registry' do
      expect(chain_dsl.registry).to be(registry)
    end
  end

  context 'when no block is given' do
    subject { chain_dsl.build(processors, failure_chain) }

    let(:expected_processors) { [processor, processor] }

    it { should eql(expected) }

    it 'injects the proper registry' do
      expect(chain_dsl.registry).to be(registry)
    end
  end
end
