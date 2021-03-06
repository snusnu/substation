# encoding: utf-8

require 'spec_helper'

describe Processor::Executor, '#compose' do
  let(:input)  { double('input') }
  let(:output) { double('output') }

  describe '#compose' do
    subject { executor.compose(input, output) }

    include_context 'Processor::Executor#initialize'

    before do
      expect(composer).to receive(:call).with(input, output).and_return(composed)
    end

    it { should be(composed) }
  end

  describe '#decompose' do
    subject { executor.decompose(input) }

    include_context 'Processor::Executor#initialize'

    before do
      expect(decomposer).to receive(:call).with(input).and_return(decomposed)
    end

    it { should be(decomposed) }
  end
end
