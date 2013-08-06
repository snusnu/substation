# encoding: utf-8

require 'spec_helper'

describe Environment, '#[]' do
  subject { object[name] }

  let(:name)      { double('name', :to_sym => :test) }
  let(:object)    { Environment.new(app_env, actions, chain_dsl) }
  let(:app_env)   { double('app_env') }
  let(:actions)   { Dispatcher.new_registry }
  let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
  let(:block)     { ->(_) { register(:test, Spec::Processor) } }

  let(:chain)         { chain_dsl.build(other, failure_chain, &chain_block) }
  let(:other)         { Chain::EMPTY }
  let(:failure_chain) { Chain::EMPTY }
  let(:chain_block)   { ->(_) { test(Spec::FAKE_HANDLER) } }

  context 'when a chain is registered under name' do
    before do
      object.register(name, &chain_block)
    end

    it { should eql(chain) }
  end

  context 'when no chain is registered under name' do
    it 'raises an error' do
      expect { subject }.to raise_error(KeyError)
    end
  end
end
