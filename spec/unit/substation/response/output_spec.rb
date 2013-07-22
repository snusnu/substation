# encoding: utf-8

require 'spec_helper'

describe Response, '#output' do

  subject { object.output }

  let(:object)   { Class.new(described_class).new(request, output) }
  let(:request)  { Request.new(name, env, input) }
  let(:name)     { double }
  let(:env)      { double }
  let(:input)    { double }
  let(:output)   { double }

  it { should equal(output) }
end
