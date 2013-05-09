# encoding: utf-8

require 'spec_helper'

describe Dispatcher, '#call' do

  subject { object.call(action_name, input, env) }

  let(:object)  { described_class.coerce(config)                        }
  let(:config)  { { 'test' => { 'action' => 'Spec::Action::Success' } } }
  let(:request) { Request.new(env, input) }
  let(:input)   { mock }
  let(:env)     { mock }

  let(:expected_response) do
    Spec::Action::Success.call(request)
  end

  context 'when the action is registered' do
    let(:action_name) { :test }

    context 'without callbacks' do
      it { should eql(expected_response) }
    end

    context 'with observers' do
      let(:config) {
        config = super()
        config['test']['observer'] = 'Spec::Observer'
        config
      }

      it 'should call callback with response' do
        Spec::Observer.should_receive(:call).with(expected_response)
        should eql(expected_response)
      end
    end
  end

  context 'when the action is not registered' do
    let(:action_name) { :unknown }

    specify do
      expect { subject }.to raise_error(described_class::UnknownActionError)
    end
  end
end
