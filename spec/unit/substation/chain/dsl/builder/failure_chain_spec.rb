# encoding: utf-8

require 'spec_helper'

describe "Initializing a processor's failure chain" do
  subject { chain.call(request) }

  let(:env) {
    Environment.build {
      register :evaluate, Processor::Evaluator::Data
      register :wrap,     Processor::Wrapper
    }
  }

  let(:chain) {
    env.chain {
      evaluate(Spec::Handler::Evaluator) {
        wrap Spec::Presenter
      }
    }
  }

  let(:request) { Request.new(name, app_env, input) }
  let(:name)    { mock }
  let(:app_env) { mock }
  let(:input)   { :invalid }

  let(:response) { Response::Failure.new(request, Spec::Presenter.new(:failure)) }

  it { should eql(response) }
end
