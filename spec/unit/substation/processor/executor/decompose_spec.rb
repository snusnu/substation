# encoding: utf-8

require 'spec_helper'

describe Processor::Executor, '#decompose' do
  subject { executor.decompose(input) }

  include_context 'Processor::Executor#initialize'

  let(:input) { double('input') }

  before do
    expect(decomposer).to receive(:call).with(input).and_return(decomposed)
  end

  it { should be(decomposed) }
end
