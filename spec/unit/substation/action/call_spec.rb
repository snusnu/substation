# encoding: utf-8

require 'spec_helper'

describe Action, '#call' do

  subject { object.call }

  let(:name)    { :test }
  let(:request) { mock(:actor => mock, :data => mock) }
  let(:env)     { Environment.new(name => { :action => Spec::Action }) }

  context "when no error occurred" do
    let(:object) { Spec::Action::Success.new(name, request, env) }

    it { should eql(Spec.success_response) }
  end

  context "when an error occurred" do
    let(:object) { Spec::Action::Failure.new(name, request, env) }

    it { should eql(Spec.failure_response) }
  end
end
