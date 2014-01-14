# encoding: utf-8

require 'spec_helper'

describe Environment, '#inherit' do

  let(:object)    { described_class.new(app_env, actions, chain_dsl) }
  let(:actions)   { double('actions') }
  let(:app_env)   { double('app_env') }
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
