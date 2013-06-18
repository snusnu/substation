# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator, '#call' do
  subject { object.call(request) }

  let(:object)  { described_class.new(Spec::Handler::Evaluator.new) }
  let(:request) { Request.new(env, input) }
  let(:env)     { mock }

  context "when evaluation is successful" do
    let(:input)    { :success }
    let(:response) { Response::Success.new(request, input) }

    it { should eql(response) }
  end

  context "when evaluation is not successful" do
    let(:input)    { :invalid }
    let(:response) { Response::Failure.new(request, :failure) }

    it { should eql(response) }
  end
end
