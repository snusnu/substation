# encoding: utf-8

require 'spec_helper'

describe Environment, '.build' do

  let(:expected)  { Environment.new(app_env, actions, chain_dsl) }
  let(:app_env)   { double('app_env') }
  let(:chain_dsl) { Chain::DSL.build(described_class::DSL.registry(&block)) }
  let(:block)     { ->(_) { register(:test, Substation) } }

  share_examples_for 'Environment.build' do
    it { should eql(expected) }

    its(:app_env) { should be(app_env) }
  end

  context 'when no actions are given' do
    subject { described_class.build(app_env, &block) }

    let(:actions) { Dispatcher::Registry.new }

    it_behaves_like 'Environment.build'

    its(:actions) { should eql(actions) }
  end

  context 'when actions are given' do
    subject { described_class.build(app_env, actions, &block) }

    let(:actions) { double('actions') }

    it_behaves_like 'Environment.build'

    its(:actions) { should be(actions) }
  end
end
