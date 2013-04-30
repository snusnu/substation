# encoding: utf-8

require 'spec_helper'

describe Action::Observable, '#call' do

  subject { object.call }

  let(:request) { mock(:actor => mock, :data => mock) }
  let(:env)     { Environment.coerce(config) }
  let(:config)  {
    {
      'test_success' => {
        'action' => 'Spec::ObservableAction::Success',
        'observers' => {
          'success' => [ 'Spec::Observer::Success' ],
          'failure' => [ 'Spec::Observer::Failure' ]
        }
      },
      'test_failure' => {
        'action' => 'Spec::ObservableAction::Failure',
        'observers' => {
          'success' => [ 'Spec::Observer::Success' ],
          'failure' => [ 'Spec::Observer::Failure' ]
        }
      }
    }
  }

  let(:now)           { DateTime.parse('Jan 5 1979') }
  let(:success_event) { Event::Success.new(object, now, Spec.success_response.data) }
  let(:failure_event) { Event::Failure.new(object, now, Spec.failure_response.data) }

  before do
    DateTime.stub!(:now).and_return(now)
  end

  context "when no error occurred" do
    let(:name)   { :test_success }
    let(:object) { Spec::ObservableAction::Success.new(name, request, env) }

    before do
      Spec::Observer::Success.should_receive(:call).with(success_event).once
      Spec::Observer::Failure.should_not_receive(:call)
    end

    it { should eql(Spec.success_response) }
  end

  context "when an error occurred" do
    let(:name)   { :test_failure }
    let(:object) { Spec::ObservableAction::Failure.new(name, request, env) }

    before do
      Spec::Observer::Failure.should_receive(:call).with(failure_event).once
      Spec::Observer::Success.should_not_receive(:call)
    end

    it { should eql(Spec.failure_response) }
  end
end
