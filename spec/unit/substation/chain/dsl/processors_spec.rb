# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '#processors' do
  subject { object.processors }

  let(:processor) { Spec::FAKE_PROCESSOR }
  let(:name)      { mock }

  shared_examples_for 'Chain::DSL#processors' do
    it { should include(processor) }
    it { should be_frozen }

    its(:length) { should == 1 }

    it 'should return a copy of the internal state' do
      expect(subject).to_not be(object.processors)
    end
  end

  context 'and a block is given' do
    let(:object) { described_class.new(chain, &block) }
    let(:chain)  { EMPTY_ARRAY }
    let(:block)  { ->(_) { use(Spec::FAKE_PROCESSOR) } }

    it_behaves_like 'Chain::DSL#processors'
  end

  context 'and no block is given' do
    let(:object) { described_class.new(chain) }
    let(:chain)  { Chain.new([ processor ], failure_chain) }
    let(:failure_chain) { mock }

    it_behaves_like 'Chain::DSL#processors'
  end
end
