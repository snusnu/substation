# encoding: utf-8

require 'spec_helper'

describe Processor::Incoming, '#result' do

  subject { object.result(response) }

  let(:object) {
    Class.new {
      include Substation::Processor::Incoming
    }.new(processor_name, handler, failure_chain)
  }

  let(:processor_name) { mock }
  let(:response)       { Response::Success.new(request, input) }
  let(:request)        { Request.new(action_name, env, input) }
  let(:action_name)    { mock }
  let(:env)            { mock }
  let(:input)          { mock }
  let(:failure_chain)  { mock }
  let(:handler)        { mock }

  it { should eql(request) }
end
