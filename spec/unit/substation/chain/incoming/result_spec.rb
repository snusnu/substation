# encoding: utf-8

require 'spec_helper'

describe Chain::Incoming, '#result' do

  subject { object.result(response) }

  let(:object) {
    Class.new {
      include Substation::Chain::Incoming
    }.new
  }

  let(:response) { Response::Success.new(request, input) }
  let(:request)  { Request.new(env, input) }
  let(:env)      { mock }
  let(:input)    { mock }

  it { should eql(request) }
end
