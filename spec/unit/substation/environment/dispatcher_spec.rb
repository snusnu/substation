# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatcher' do
  subject { object.dispatcher(dispatch_table, app_env) }

  let(:object)      { described_class.new(chain_dsl) }
  let(:chain_dsl)   { double('chain_dsl', :registry => registry) }
  let(:registry)    { double('registry') }
  let(:app_env)     { double('app_env') }

  let(:dispatch_table) { double('dispatch_table') }
  let(:dispatcher)     { double('dispatcher') }

  before do
    expect(Dispatcher).to receive(:new).with(dispatch_table, app_env).and_return(dispatcher)
  end

  it { should eql(dispatcher) }
end
