# encoding: utf-8

require 'spec_helper'

describe Processor::Executor::NULL, '#decompose' do
  subject { described_class.decompose(input) }

  let(:input) { double('input') }

  it 'should return the input unaltered' do
    expect(subject).to be(input)
  end
end
