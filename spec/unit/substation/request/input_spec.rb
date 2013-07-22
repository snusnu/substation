# encoding: utf-8

require 'spec_helper'

describe Request, '#input' do

  subject { object.input }

  let(:object) { described_class.new(name, env, input) }
  let(:name)   { double }
  let(:env)    { double }
  let(:input)  { double }

  it { should be(input) }
end
