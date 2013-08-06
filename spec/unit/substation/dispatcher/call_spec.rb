# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#call' do

  subject { object.call(name, input) }

  include_context 'Request#initialize'

  let(:object)  { described_class.new(config, env) }
  let(:config)  { DSL::Registry.new(guard, :test => Spec::Action::Success) }
  let(:guard)   { double('guard') }

  let(:expected_response) do
    Spec::Action::Success.call(request)
  end

  context 'when the action is registered' do
    let(:name) { :test }

    it { should eql(expected_response) }
  end

  context 'when the action is not registered' do
    let(:name) { :unknown }

    specify do
      expect { subject }.to raise_error(described_class::UnknownActionError)
    end
  end
end
