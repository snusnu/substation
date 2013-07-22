# encoding: utf-8

require 'spec_helper'

describe Chain::DSL, '.build' do

  let(:chain) { EMPTY_ARRAY }
  let(:failure_chain) { EMPTY_ARRAY }

  context 'and a block is given' do
    subject { described_class.build(chain, failure_chain, &block) }

    let(:block) { ->(_) { use(Spec::FAKE_PROCESSOR) } }

    it { should eql(Chain.new([Spec::FAKE_PROCESSOR], failure_chain)) }
  end

  context 'and no block is given' do
    subject { described_class.build(chain, failure_chain) }

    it { should eql(Chain::EMPTY) }
  end
end
