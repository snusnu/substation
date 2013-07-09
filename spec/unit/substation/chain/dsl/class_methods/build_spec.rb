# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '.build' do

  let(:chain) { EMPTY_ARRAY }
  let(:failure_chain) { Chain::EMPTY }

  context 'and a block is given' do
    subject { described_class.build(chain, failure_chain, &block) }

    let(:block)     { ->(_) { use(Spec::FAKE_PROCESSOR) } }
    let(:processor) { Spec::FAKE_PROCESSOR }

    it { should include(processor) }
  end

  context 'and no block is given' do
    subject { described_class.build(chain, failure_chain) }

    its(:processors) { should be_empty }
  end
end
