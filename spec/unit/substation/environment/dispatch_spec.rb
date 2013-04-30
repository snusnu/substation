# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatch' do

  subject { object.dispatch(action_name, request) }

  let(:object)  { described_class.coerce(config) }
  let(:config)  { { 'test' => { 'action' => 'Spec::Action::Success' } } }
  let(:request) { mock(:actor => mock, :data => mock) }

  context "when the action is registered" do
    let(:action_name) { :test }

    it { should eql(Spec::Action::Success.call(action_name, request, object)) }
  end

  context "when the action is not registered" do
    let(:action_name) { :unknown }

    specify do
      expect { subject }.to raise_error(described_class::UnknownActionError)
    end
  end
end
