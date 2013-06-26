# encoding: utf-8

require 'spec_helper'

describe Response, '#to_request' do

  subject { object.to_request }

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { mock }
  let(:env)      { mock }
  let(:input)    { mock }
  let(:output)   { mock }

  let(:response) { Request.new(name, env, output) }

  it { should eql(response) }
end
