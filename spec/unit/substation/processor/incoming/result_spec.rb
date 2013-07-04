# encoding: utf-8

require 'spec_helper'

describe Processor::Incoming, '#result' do

  subject { object.result(response) }

  let(:object) {
    Class.new {
      include Substation::Processor::Incoming
    }.new(failure_chain, handler)
  }

  let(:response) { Response::Success.new(request, input) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { mock }
  let(:env)      { mock }
  let(:input)    { mock }

  let(:failure_chain) { mock }
  let(:handler)       { mock }

  it { should eql(request) }
end
