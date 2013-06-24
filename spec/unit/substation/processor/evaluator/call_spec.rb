# encoding: utf-8

require 'spec_helper'

describe Processor::Evaluator, '#call' do
  subject { object.call(request) }

  let(:request) { Request.new(mock('env'), input) }

  context "when no failure chain is registered" do

    let(:object) { described_class.new(Spec::FAKE_ENV, Spec::Handler::Evaluator.new) }

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

  context "when a failure chain is registered" do

    let(:object) { described_class.new(env, Spec::Handler::Evaluator.new, &block) }
    let(:env)    { Environment.new({}) }
    let(:block)  { lambda { |_| use(Processor::Wrapper.new(env, Spec::Presenter)) } }

    context "when evaluation is successful" do
      let(:input)    { :success }
      let(:response) { Response::Success.new(request, input) }

      it { should eql(response) }
    end

    context "when evaluation is not successful" do
      let(:input)    { :invalid }
      let(:response) { Response::Failure.new(request, Spec::Presenter.new(:failure)) }

      it { should eql(response) }
    end
  end
end
