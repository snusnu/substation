# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator, '#call' do
  subject { object.call(request) }

  let(:object)           { klass.new(failure_chain, handler) }
  let(:klass)            { Class.new(described_class) { include Processor::Incoming } }
  let(:failure_chain)    { mock(:call => failure_response) }
  let(:failure_response) { mock }
  let(:request)          { Request.new(name, env, input) }
  let(:name)             { mock }
  let(:env)              { mock }
  let(:input)            { mock }

  context "with a successful handler" do
    let(:handler)  { Spec::Action::Success }
    let(:response) { Response::Success.new(request, Spec.response_data) }

    it { should eql(response) }
  end

  context "with a failing handler" do
    let(:handler)  { Spec::Action::Failure }
    let(:response) { Response::Failure.new(request, Spec.response_data) }

    before do
      failure_chain.should_receive(:call).with(response).and_return(failure_response)
    end

    it { should eql(failure_response) }
  end
end
