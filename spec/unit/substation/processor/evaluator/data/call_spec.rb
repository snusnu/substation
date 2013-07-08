# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator::Data, '#call' do
  subject { object.call(request) }

  let(:object)           { described_class.new(processor_name, handler, failure_chain) }
  let(:processor_name)   { mock }
  let(:failure_chain)    { mock(:call => failure_response) }
  let(:failure_response) { mock }
  let(:handler)          { Spec::Handler::Evaluator }
  let(:request)          { Request.new(action_name, env, input) }
  let(:action_name)      { mock }
  let(:env)              { mock }

  context 'with a successful handler' do
    let(:input)    { :success }
    let(:response) { request.success(input) }

    it { should eql(response) }
  end

  context 'with a failing handler' do
    let(:input)    { :foo }
    let(:response) { request.error(:failure) }

    before do
      failure_chain.should_receive(:call).with(response).and_return(failure_response)
    end

    it { should eql(failure_response) }
  end
end
