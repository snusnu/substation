# encoding: utf-8

require 'spec_helper'

describe Response, '#to_request' do

  subject { object.to_request }

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { double }
  let(:env)      { double }
  let(:input)    { double }
  let(:output)   { double }

  let(:response) { Request.new(name, env, output) }

  it { should eql(response) }
end
