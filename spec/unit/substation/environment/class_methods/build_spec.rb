# encoding: utf-8

require 'spec_helper'

describe Environment, '.build' do
  subject { described_class.build(&block) }

  let(:expected)  { Environment.new(registry, chain_dsl) }
  let(:chain_dsl) { Chain::DSL::Builder.call(registry) }
  let(:registry)  { described_class::DSL.new(&block).registry }
  let(:block)     { ->(_) { register(:test, Substation) } }

  it { should eql(expected) }

  it 'uses the compiled dsl' do
    expect(subject.chain).to eql(chain_dsl.build(Chain::EMPTY, Chain::EMPTY))
  end
end
