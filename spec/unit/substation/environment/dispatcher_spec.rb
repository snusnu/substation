# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatcher' do
  subject { object.dispatcher }

  let(:object)      { described_class.new(app_env, actions, chain_dsl) }
  let(:app_env)     { double('app_env') }
  let(:actions)     { double('actions') }
  let(:chain_dsl)   { double('chain_dsl', :registry => registry) }
  let(:registry)    { double('registry') }

  let(:expected)    { Dispatcher.new(actions, app_env) }

  it { should eql(expected) }
end
