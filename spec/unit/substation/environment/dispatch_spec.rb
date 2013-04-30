# encoding: utf-8

require 'spec_helper'

describe Environment, '#dispatch' do

  subject { object.dispatch(action_name, request) }

  let(:object)      { described_class.coerce(config) }
  let(:config)      { { 'test' => { 'action' => 'Spec::Action::Success' } } }
  let(:action_name) { :test }
  let(:request)     { mock(:actor => mock, :data => mock) }

  it { should eql(Spec::Action::Success.call(action_name, request, object)) }
end

