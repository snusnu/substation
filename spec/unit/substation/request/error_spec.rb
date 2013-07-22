# encoding: utf-8

require 'spec_helper'

describe Request, '#error' do

  subject { object.error(output) }

  let(:object) { described_class.new(name, env, input) }
  let(:name)   { double }
  let(:env)    { double }
  let(:input)  { double }
  let(:output) { double }

  it { should eql(Response::Failure.new(object, output)) }
end
