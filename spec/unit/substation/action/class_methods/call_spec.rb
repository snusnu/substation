# encoding: utf-8

require 'spec_helper'

describe Action, '.call' do

  subject { object.call(name, request, env) }

  let(:name)      { :test }
  let(:request)   { mock(:actor => mock, :data => mock) }
  let(:env)       { Environment.new(name => action) }
  let(:action)    { Environment::Action.new(name, object, observers) }
  let(:observers) { Environment::Observers.new({}) }

  context "when no error occurred" do
    let(:object) { Spec::Action::Success }

    it { should eql(Spec.success_response) }
  end

  context "when an error occurred" do
    let(:object) { Spec::Action::Failure }

    it { should eql(Spec.failure_response) }
  end
end
