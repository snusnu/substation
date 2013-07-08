# encoding: utf-8

require 'spec_helper'

describe Processor, '#result' do

  subject { object.result(response) }

  let(:object) {
    Class.new {
      include Substation::Processor
    }.new(processor_name, handler)
  }

  let(:processor_name) { mock }
  let(:response)       { Response::Success.new(request, input) }
  let(:request)        { Request.new(action_name, env, input) }
  let(:action_name)    { mock }
  let(:env)            { mock }
  let(:input)          { mock }
  let(:handler)        { mock }

  it { should be(response) }
end
