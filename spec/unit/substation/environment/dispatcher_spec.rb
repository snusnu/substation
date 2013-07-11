# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatcher' do

  let(:object)      { described_class.new(registry, chain_dsl) }
  let(:registry)    { mock }
  let(:chain_dsl)   { mock }
  let(:env)         { mock }

  context 'when no block is given' do
    subject { object.dispatcher(env) }

    it { should eql(Dispatcher.new({}, env)) }
  end

  context 'when a block is given' do
    subject { object.dispatcher(env, &block) }

    let(:block) { ->(_) { dispatch :test, Chain::EMPTY } }

    it { should eql(Dispatcher.new({ :test => Chain::EMPTY }, env)) }
  end
end
