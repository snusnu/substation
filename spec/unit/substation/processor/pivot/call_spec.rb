# encoding: utf-8

require 'spec_helper'

describe Processor::Pivot, '#call' do
  subject { object.call(request) }

  let(:object)  { described_class.new(Spec::Handler::Pivot.new) }
  let(:request) { Request.new(env, input) }
  let(:env)     { mock }
  let(:input)   { mock }

  let(:response) { Response::Success.new(request, request.input) }

  it { should eql(response) }
end
