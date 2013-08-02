# encoding: utf-8

require 'spec_helper'

describe Environment, '#actions' do
  subject { object.actions }

  let(:object)    { Environment.new(app_env, actions, chain_dsl) }
  let(:app_env)   { double('app_env') }
  let(:actions)   { double('actions') }
  let(:chain_dsl) { double('app_env', :registry => registry) }
  let(:registry)  { double('registry') }

  it { should be(actions) }
end
