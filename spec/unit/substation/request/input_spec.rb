# encoding: utf-8

require 'spec_helper'

describe Request, '#input' do

  subject { object.input }

  let(:object) { described_class.new(name, env, input) }
  let(:name)   { mock }
  let(:env)    { mock }
  let(:input)  { mock }

  it { should be(input) }
end
