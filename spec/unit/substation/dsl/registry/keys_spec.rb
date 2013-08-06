# encoding: utf-8

require 'spec_helper'

describe DSL::Registry, '#keys' do
  subject { object.keys }

  let(:object)  { described_class.new(guard, entries) }
  let(:guard)   { double('guard') }
  let(:entries) { { key => value } }
  let(:key)     { double('key') }
  let(:value)   { double('value') }

  it { should eql([key]) }
end
