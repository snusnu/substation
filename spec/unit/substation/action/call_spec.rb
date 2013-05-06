# encoding: utf-8

require 'spec_helper'

describe Action, '#call' do

  subject { object.call }

  let(:name)    { :test }
  let(:request) { mock(:actor => mock, :data => mock) }
  let(:env)     { Environment.new(name => { :action => Spec::Action }) }

  context "when no error occurred" do
    let(:object) { Spec::Action::Success.new(env, request) }

    it { should eql(Spec.success_response(request)) }
  end

  context "when an error occurred" do
    let(:object) { Spec::Action::Failure.new(env, request) }

    it { should eql(Spec.failure_response(request)) }
  end
end
