# encoding: utf-8

require 'spec_helper'

describe Processor, '#result' do

  subject { object.result(response) }

  let(:object) {
    Class.new {
      include Substation::Processor
    }.new
  }

  let(:response) { Response::Success.new(request, input) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { mock }
  let(:env)      { mock }
  let(:input)    { mock }

  it { should be(response) }
end
