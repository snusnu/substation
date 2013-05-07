# encoding: utf-8

require 'spec_helper'

describe Action, '.call' do

  subject { object.call(env, request) }

  let(:name)     { :test                                     }
  let(:request)  { mock(:actor => mock, :data => mock)       }
  let(:env)      { Environment.new(name => action)           }
  let(:action)   { Environment::Action.new(object, observer) }
  let(:observer) { Observer::Null                            }

  context "when no error occurred" do
    let(:object) { Spec::Action::Success }

    it { should eql(Spec.success_response(request)) }
  end

  context "when an error occurred" do
    let(:object) { Spec::Action::Failure }

    it { should eql(Spec.failure_response(request)) }
  end
end
