# encoding: utf-8

require 'spec_helper'

describe Environment, '#app_env' do
  subject { object.app_env }

  let(:object)    { Environment.new(app_env, actions, chain_dsl) }
  let(:app_env)   { double('app_env') }
  let(:actions)   { double('actions') }
  let(:chain_dsl) { double('app_env', :registry => registry) }
  let(:registry)  { double('registry') }

  it { should be(app_env) }
end
