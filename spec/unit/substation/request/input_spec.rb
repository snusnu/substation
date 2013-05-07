# encoding: utf-8

require 'spec_helper'

describe Request, '#input' do

  subject { object.input }

  let(:object) { described_class.new(env, input) }
  let(:env)    { mock }
  let(:input)  { mock }

  it { should equal(input) }
end
