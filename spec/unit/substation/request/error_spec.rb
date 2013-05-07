# encoding: utf-8

require 'spec_helper'

describe Request, '#error' do

  subject { object.error(output) }

  let(:object) { described_class.new(env, input) }
  let(:env)    { mock }
  let(:input)  { mock }
  let(:output) { mock }

  it { should eql(Response::Failure.new(object, output)) }
end
