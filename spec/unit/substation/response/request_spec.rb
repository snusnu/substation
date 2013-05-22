# encoding: utf-8

require 'spec_helper'

describe Response, '#request' do

  subject { object.request }

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:request)  { Request.new(env, input) }
  let(:env)      { mock }
  let(:input)    { mock }
  let(:output)   { mock }

  it { should equal(request) }
end
