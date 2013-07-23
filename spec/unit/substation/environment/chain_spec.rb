# encoding: utf-8

require 'spec_helper'

describe Substation::Environment, '#chain' do

  let(:object) { described_class.new(registry, dsl) }

  let(:dsl)      { Chain::DSL::Builder.call(registry) }
  let(:registry) { described_class::DSL.registry(&r_block) }
  let(:r_block)  { ->(_) { register(:test, Spec::Processor) } }

  let(:other)         { double('other', :each => EMPTY_ARRAY) }
  let(:failure_chain) { double('failure_chain') }
  let(:block)         { ->(_) { test Spec::FAKE_HANDLER, Chain::EMPTY } }

  context 'when other, failure_chain and block are given' do
    subject { object.chain(other, failure_chain, &block) }

    it { should eql(dsl.build(other, failure_chain, &block)) }
  end

  context 'when other, failure_chain and no block are given' do
    subject { object.chain(other, failure_chain) }

    it { should eql(dsl.build(other, failure_chain)) }
  end

  context 'when other, no failure_chain and no block are given' do
    subject { object.chain(other) }

    it { should eql(dsl.build(other, Chain::EMPTY)) }
  end

  context 'when no parameters are given' do
    subject { object.chain }

    it { should eql(dsl.build(Chain::EMPTY, Chain::EMPTY)) }
  end
end
