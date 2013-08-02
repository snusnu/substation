# encoding: utf-8

require 'spec_helper'

describe Environment, '#register' do
  let(:object)    { Environment.new(app_env, actions, chain_dsl) }
  let(:app_env)   { double('app_env') }
  let(:actions)   { Dispatcher::Registry.new }
  let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
  let(:block)     { ->(_) { register(:test, Spec::Processor) } }

  let(:chain)       { chain_dsl.build(other, failure_chain, &chain_block) }
  let(:chain_block) { ->(_) { test(Spec::FAKE_HANDLER) } }

  let(:name)          { double('name', :to_sym => :test) }
  let(:other)         { Chain::EMPTY }
  let(:failure_chain) { Chain::EMPTY }

  share_examples_for 'Environment#register' do
    it_behaves_like 'a command method'

    it 'registers the chain under the given name' do
      subject
      expect(object[name]).to eql(chain)
    end
  end

  context 'when other and failure_chain are not given' do
    subject { object.register(name, &chain_block) }

    it_behaves_like 'Environment#register'
  end

  context 'when other is given and failure_chain is not given' do
    subject { object.register(name, other, &chain_block) }

    it_behaves_like 'Environment#register'
  end

  context 'when both other and failure_chain are given' do
    subject { object.register(name, other, failure_chain, &chain_block) }

    it_behaves_like 'Environment#register'
  end
end
