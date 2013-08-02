# encoding: utf-8

require 'spec_helper'

describe Environment, '#inherit' do

  let(:object)    { described_class.new(app_env, actions, chain_dsl) }
  let(:actions)   { double('actions') }
  let(:app_env)   { double('app_env') }
  let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&env_block)) }
  let(:env_block) {
    ->(_) {
      register(:test_1, Spec::Transformer)
      register(:test_2, Spec::Transformer)
    }
  }

  let(:expected)  { described_class.build(app_env, actions, &expected_block) }

  let(:expected_block) {
    ->(_) {
      register(:test_1, Spec::Processor)
      register(:test_2, Spec::Transformer)
      register(:test_3, Spec::Processor)
    }
  }

  let(:block) {
    ->(_) {
      register(:test_1, Spec::Processor)
      register(:test_3, Spec::Processor)
    }
  }

  context 'when no actions are given' do
    subject { object.inherit(&block) }

    let(:new_actions) { Dispatcher::Registry.new }

    it { should eql(expected) }

    its(:actions) { should eql(new_actions) }
  end

  context 'when actions are given' do
    subject { object.inherit(new_actions, &block) }

    let(:new_actions) { double('new_actions') }

    it { should eql(expected) }

    its(:actions) { should be(new_actions) }
  end
end
