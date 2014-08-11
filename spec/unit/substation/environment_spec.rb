# encoding: utf-8

require 'spec_helper'

describe Environment do
  let(:object)   { described_class.new(app_env, actions, chain_dsl) }
  let(:app_env)  { double('app_env') }
  let(:actions)  { Dispatcher.new_registry }
  let(:registry) { double('registry') }

  describe '#actions' do
    subject { object.actions }

    let(:chain_dsl) { double('app_env', :registry => registry) }

    it { should be(actions) }
  end

  describe '#app_env' do
    subject { object.app_env }

    let(:chain_dsl) { double('app_env', :registry => registry) }

    it { should be(app_env) }
  end

  describe '#chain' do
    let(:chain_dsl) { Chain::DSL.build(registry) }
    let(:registry)  { described_class::DSL.registry(&r_block) }
    let(:r_block)   { ->(_) { register(:test, Spec::Processor) } }

    let(:other)         { double('other', :each => EMPTY_ARRAY) }
    let(:failure_chain) { double('failure_chain') }
    let(:block)         { ->(_) { test Spec::FAKE_HANDLER, Chain::EMPTY } }

    let(:name)     { double('name') }

    context 'when other, failure_chain and block are given' do
      subject { object.chain(name, other, failure_chain, &block) }

      it { should eql(chain_dsl.build(name, other, failure_chain, &block)) }
    end

    context 'when other, failure_chain and no block are given' do
      subject { object.chain(name, other, failure_chain) }

      it { should eql(chain_dsl.build(name, other, failure_chain)) }
    end

    context 'when other, no failure_chain and no block are given' do
      subject { object.chain(name, other) }

      it { should eql(chain_dsl.build(name, other, Chain::EMPTY)) }
    end

    context 'when no parameters are given' do
      subject { object.chain }

      it { should eql(chain_dsl.build(nil, Chain::EMPTY, Chain::EMPTY)) }
    end
  end

  describe '#dispatcher' do
    subject { object.dispatcher }

    let(:chain_dsl)   { double('chain_dsl', :registry => registry) }

    let(:expected)    { Dispatcher.new(actions, app_env) }

    it { should eql(expected) }
  end

  describe '#[]' do
    subject { object[name] }

    let(:name)      { double('name', :to_sym => :test) }
    let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
    let(:block)     { ->(_) { register(:test, Spec::Processor) } }

    let(:chain)         { chain_dsl.build(name, other, failure_chain, &chain_block) }
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

  describe 'equalizer behavior' do
    subject { object == other }


    let(:chain_dsl) { double('chain_dsl', :registry => registry) }

    let(:other)  { described_class.new(app_env, actions, other_chain_dsl) }
    let(:other_chain_dsl) {
      double('other_chain_dsl', :registry => other_registry)
    }

    context 'with an equal registry' do
      let(:other_registry) { registry }

      it { should be(true) }
    end

    context 'with a different registry' do
      let(:other_registry) { double('other_registry') }

      it { should be(false) }
    end
  end

  describe '#inherit' do

    let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&env_block)) }
    let(:env_block) {
      ->(_) {
        register(:test_1, Spec::Processor)
        register(:test_2, Spec::Processor)
      }
    }

    let(:expected)  { described_class.build(app_env, actions, &expected_block) }

    let(:expected_block) {
      ->(_) {
        register(:test_1, Spec::Processor)
        register(:test_2, Spec::Processor)
        register(:test_3, Spec::Processor)
      }
    }

    let(:block) {
      ->(_) {
        register(:test_3, Spec::Processor)
      }
    }

    context 'when no app_env and actions are given' do
      subject { object.inherit(&block) }

      let(:new_actions) { Dispatcher.new_registry }

      it { should eql(expected) }

      its(:app_env) { should eql(app_env) }
      its(:actions) { should eql(new_actions) }
    end

    context 'when app_env is given' do
      subject { object.inherit(new_app_env, &block) }

      let(:expected)    { described_class.build(new_app_env, actions, &expected_block) }
      let(:new_app_env) { double('new_app_env') }
      let(:new_actions) { Dispatcher.new_registry }

      it { should eql(expected) }

      its(:app_env) { should eql(new_app_env) }
      its(:actions) { should eql(new_actions) }
    end

    context 'when app_env and actions are given' do
      subject { object.inherit(app_env, new_actions, &block) }

      let(:new_actions) { double('new_actions') }

      it { should eql(expected) }

      its(:app_env) { should eql(app_env) }
      its(:actions) { should be(new_actions) }
    end
  end

  describe '#register' do
    let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
    let(:block)     { ->(_) { register(:test, Spec::Processor) } }

    let(:chain_block) { ->(_) { test(Spec::FAKE_HANDLER) } }

    let(:name)          { double('name', :to_sym => :test) }
    let(:other)         { Chain::EMPTY }
    let(:failure_chain) { double }

    shared_examples 'Environment#register' do
      it_behaves_like 'a command method'

      it 'registers the chain under the given name' do
        subject
        expect(object[name]).to eql(chain)
      end
    end

    context 'when other and failure_chain are not given' do
      subject { object.register(name, &chain_block) }

      let(:chain) { chain_dsl.build(name, Chain::EMPTY, Chain::EMPTY, &chain_block) }

      it_behaves_like 'Environment#register'
    end

    context 'when other is given and failure_chain is not given' do
      subject { object.register(name, other, &chain_block) }

      let(:chain) { chain_dsl.build(name, other, Chain::EMPTY, &chain_block) }

      it_behaves_like 'Environment#register'
    end

    context 'when both other and failure_chain are given' do
      subject { object.register(name, other, failure_chain, &chain_block) }

      let(:chain) { chain_dsl.build(name, other, failure_chain, &chain_block) }

      it_behaves_like 'Environment#register'
    end
  end

  describe '.build' do

    let(:expected)  { described_class.new(app_env, actions, chain_dsl) }
    let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
    let(:block)     { ->(_) { register(:test, Substation) } }

    shared_examples 'Environment.build' do
      it { should eql(expected) }

      its(:app_env) { should be(app_env) }
    end

    context 'when no actions are given' do
      subject { described_class.build(app_env, &block) }


      it_behaves_like 'Environment.build'

      its(:actions) { should eql(actions) }
    end

    context 'when actions are given' do
      subject { described_class.build(app_env, actions, &block) }

      it_behaves_like 'Environment.build'

      its(:actions) { should be(actions) }
    end
  end
end
