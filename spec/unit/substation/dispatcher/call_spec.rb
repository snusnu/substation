# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#call' do

  subject { object.call(action_name, input) }

  let(:object)  { described_class.new(config, env) }
  let(:config)  { { :test => Spec::Action::Success } }
  let(:request) { Request.new(action_name, env, input) }
  let(:env)     { double }
  let(:input)   { double }

  let(:expected_response) do
    Spec::Action::Success.call(request)
  end

  context 'when the action is registered' do
    let(:action_name) { :test }

    it { should eql(expected_response) }
  end

  context 'when the action is not registered' do
    let(:action_name) { :unknown }

    specify do
      expect { subject }.to raise_error(described_class::UnknownActionError)
    end
  end
end
