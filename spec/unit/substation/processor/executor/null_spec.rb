# encoding: utf-8

require 'spec_helper'

describe Processor::Executor::NULL do

  let(:input)  { double('input') }
  let(:output) { double('output') }

  describe '#compose' do
    subject { described_class.compose(input, output) }

    it 'should return the output unaltered' do
      expect(subject).to be(output)
    end
  end

  describe '#decompose' do
    subject { described_class.decompose(input) }

    it 'should return the input unaltered' do
      expect(subject).to be(input)
    end
  end
end
