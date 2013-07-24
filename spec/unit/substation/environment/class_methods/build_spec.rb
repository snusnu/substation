# encoding: utf-8

require 'spec_helper'

describe Environment, '.build' do

  let(:expected)  { Environment.new(registry, chain_dsl) }
  let(:chain_dsl) { Chain::DSL::Builder.call(registry) }
  let(:registry)  { described_class::DSL.new(&block).registry }
  let(:block)     { ->(_) { register(:test, Substation) } }

  context 'when no other environment is given' do
    subject { described_class.build(&block) }

    it { should eql(expected) }

    it 'uses the compiled dsl' do
      expect(subject.chain).to eql(chain_dsl.build(Chain::EMPTY, Chain::EMPTY))
    end
  end

  context 'when other environment is given' do
    subject { described_class.build(other, &block) }

    let(:other)  { double('other') }
    let(:merged) { double('merged') }

    before do
      expect(other).to receive(:merge).with(expected).and_return(merged)
    end

    it { should eql(merged) }
  end
end
