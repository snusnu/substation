# encoding: utf-8

require 'spec_helper'

describe Processor::Transformer, '#call' do
  subject { object.call(response) }

  let(:object)         { described_class.new(processor_name, Spec::Transformer) }
  let(:processor_name) { mock }
  let(:response)       { Response::Success.new(request, output) }
  let(:request)        { Request.new(action_name, env, input) }
  let(:action_name)    { mock }
  let(:env)            { mock }
  let(:input)          { mock }
  let(:output)         { mock }

  let(:transformed) { Response::Success.new(request, data) }
  let(:data)        { Spec::Transformer.call(response) }

  it { should eql(transformed) }
end
