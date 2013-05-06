# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatch' do

  subject { object.dispatch(action_name, request) }

  let(:object)  { described_class.coerce(config)                        }
  let(:config)  { { 'test' => { 'action' => 'Spec::Action::Success' } } }
  let(:request) { mock(:actor => mock, :data => mock)                   }

  let(:expected_response) do
    Spec::Action::Success.call(object, request)
  end

  let(:action_name) { :test }

  context 'when the action is registered' do
    context 'without callbacks' do
      it { should eql(expected_response) }
    end

    context 'with observers' do
      let(:config) do
        config = super()
        config['test']['observer'] = 'Spec::Observer'
        config
      end

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
