# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '.build' do

  let(:processors) { [processor] }
  let(:processor)  { double('processor') }
  let(:failure_chain) { EMPTY_ARRAY }

  context 'and a block is given' do
    subject { described_class.build(processors, failure_chain, &block) }

    let(:block)      { ->(_) { use(Spec::FAKE_PROCESSOR) } }
    let(:definition) { Chain::Definition.new([processor, Spec::FAKE_PROCESSOR]) }

    it { should eql(Chain.new(definition, failure_chain)) }
  end

  context 'and no block is given' do
    subject { described_class.build(processors, failure_chain) }

    let(:definition) { Chain::Definition.new([processor]) }

    it { should eql(Chain.new(definition, failure_chain)) }
  end
end
