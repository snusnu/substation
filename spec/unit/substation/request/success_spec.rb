# encoding: utf-8

require 'spec_helper'

describe Request, '#success' do

  subject { object.success(output) }

  let(:object) { described_class.new(name, env, input) }
  let(:name)   { mock }
  let(:env)    { mock }
  let(:input)  { mock }
  let(:output) { mock }

  it { should eql(Response::Success.new(object, output)) }
end
